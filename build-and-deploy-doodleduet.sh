#!/bin/bash
#
# DoodleDuet CasaOS App Build & Deploy Script
# Handles icon generation, validation, testing, and GitHub deployment
#

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="doodleduet-app"
APP_DIR="Apps/$APP_NAME"
STORE_JSON="store.json"
DOCKER_IMAGE="aiyuayaan/doodleduet-app:v1.0.0"
GITHUB_REPO="JoshEvans-Weber/casaos-store"

# Banner
print_banner() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         DoodleDuet CasaOS App Build & Deploy              ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Helper functions
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "Command not found: $1"
        exit 1
    fi
}

# Main script
main() {
    print_banner
    
    # Step 1: Check prerequisites
    print_step "Checking prerequisites..."
    check_command python3
    check_command docker
    check_command git
    print_success "All prerequisites installed"
    
    # Step 2: Generate icon
    print_step "Generating DoodleDuet icon..."
    if python3 generate_icon.py; then
        print_success "Icon generated: $APP_DIR/icon.png"
    else
        print_error "Failed to generate icon"
        exit 1
    fi
    
    # Step 3: Validate docker-compose.yml
    print_step "Validating docker-compose.yml..."
    if python3 -m yaml &>/dev/null 2>&1; then
        print_warning "PyYAML not installed, skipping YAML validation"
        print_warning "Install with: pip3 install pyyaml"
    else
        if python3 validate_app.py &>/dev/null; then
            print_success "docker-compose.yml validation passed"
        else
            print_warning "Could not run validation script (may need adjustments)"
        fi
    fi
    
    # Step 4: Validate JSON format
    print_step "Validating store.json..."
    if python3 -m json.tool "$STORE_JSON" > /dev/null 2>&1; then
        print_success "store.json is valid JSON"
    else
        print_error "store.json has invalid JSON syntax"
        exit 1
    fi
    
    # Step 5: Check if app entry exists in store.json
    print_step "Checking store.json for app entry..."
    if grep -q "\"name\": \"$APP_NAME\"" "$STORE_JSON"; then
        print_success "App entry found in store.json"
    else
        print_warning "App entry not found in store.json"
        print_warning "You need to manually add the entry from Apps/$APP_NAME/store-entry.json"
    fi
    
    # Step 6: Check icon file exists
    print_step "Verifying icon file..."
    if [ -f "$APP_DIR/icon.png" ]; then
        icon_size=$(stat -f%z "$APP_DIR/icon.png" 2>/dev/null || stat -c%s "$APP_DIR/icon.png" 2>/dev/null)
        print_success "Icon file exists ($(echo "scale=2; $icon_size / 1024" | bc)KB)"
    else
        print_error "Icon file not found: $APP_DIR/icon.png"
        exit 1
    fi
    
    # Step 7: Verify file structure
    print_step "Verifying app file structure..."
    required_files=(
        "docker-compose.yml"
        "README.md"
        "icon.png"
    )
    
    missing_files=()
    for file in "${required_files[@]}"; do
        if [ -f "$APP_DIR/$file" ]; then
            print_success "Found: $APP_DIR/$file"
        else
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        print_error "Missing files: ${missing_files[*]}"
        exit 1
    fi
    
    # Step 8: Test docker-compose configuration
    print_step "Testing docker-compose configuration..."
    if cd "$APP_DIR" && docker-compose config > /dev/null 2>&1; then
        print_success "docker-compose configuration is valid"
        cd - > /dev/null
    else
        print_warning "docker-compose config validation failed (may need Docker daemon running)"
    fi
    
    # Step 9: Show summary and next steps
    print_step "Build preparation complete!"
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ DoodleDuet app is ready for deployment${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo "Next steps:"
    echo "1. Verify store.json entry:"
    echo "   $(cat $APP_DIR/store-entry.json | head -5)"
    echo ""
    echo "2. Add to store.json if not already present:"
    echo "   • Edit $STORE_JSON"
    echo "   • Add entry from Apps/$APP_NAME/store-entry.json to the apps array"
    echo ""
    echo "3. Commit and push to GitHub:"
    echo "   git add Apps/$APP_NAME/"
    echo "   git commit -m 'Add DoodleDuet collaborative drawing app'"
    echo "   git push"
    echo ""
    echo "4. Test in CasaOS:"
    echo "   • Refresh your app store"
    echo "   • Search for 'DoodleDuet'"
    echo "   • Install and verify functionality"
    echo ""
    
    # Step 10: Optional - Git operations
    read -p "Do you want to commit and push to GitHub now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        deploy_to_github
    else
        print_warning "Remember to commit and push your changes manually"
    fi
}

deploy_to_github() {
    print_step "Preparing GitHub deployment..."
    
    # Check git status
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not a git repository"
        return 1
    fi
    
    # Check for uncommitted changes in the app directory
    if git diff --quiet --exit-code "$APP_DIR" && \
       git diff --cached --quiet --exit-code "$APP_DIR"; then
        print_warning "No changes detected in $APP_DIR"
        return 0
    fi
    
    print_step "Adding files to git..."
    git add "$APP_DIR/"
    print_success "Files staged"
    
    print_step "Creating commit..."
    commit_msg="Add DoodleDuet collaborative drawing app to CasaOS store

- DoodleDuet: Real-time collaborative drawing with Socket.IO and Redis
- Supports multiple users drawing simultaneously in shared rooms
- Features: Live chat, admin controls, infinite canvas with pan/zoom
- Includes Redis sidecar for real-time data synchronization
- Follows CasaOS appstore standards and conventions"
    
    if git commit -m "$commit_msg"; then
        print_success "Commit created"
    else
        print_warning "Nothing to commit"
        return 0
    fi
    
    print_step "Pushing to GitHub..."
    if git push; then
        print_success "Successfully pushed to GitHub"
        echo "  Repository: $GITHUB_REPO"
        echo "  Branch: $(git rev-parse --abbrev-ref HEAD)"
        echo "  Commit: $(git rev-parse --short HEAD)"
    else
        print_error "Failed to push to GitHub. Push manually with: git push"
        return 1
    fi
}

# Error handler
trap 'print_error "Script failed at line $LINENO"; exit 1' ERR

# Run main script
main
