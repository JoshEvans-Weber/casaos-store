#!/usr/bin/env python3
"""
DoodleDuet CasaOS App - Complete Build & Deploy Automation
Handles: Icon generation, Docker build, GitHub Container Registry push, 
store.json update, and git commits
"""

import os
import sys
import json
import subprocess
import argparse
from pathlib import Path
from datetime import datetime
from typing import Tuple, Optional

# Configuration
APP_NAME = "doodleduet-app"
APP_DIR = Path("Apps") / APP_NAME
STORE_JSON = Path("store.json")
DOCKER_IMAGE_ORIGINAL = "aiyuayaan/doodleduet-app:v1.0.0"
GITHUB_USERNAME = None  # Will be fetched from git config
GHCR_IMAGE_BASE = "ghcr.io"  # GitHub Container Registry

# Color codes
class Colors:
    BLUE = '\033[0;34m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    RED = '\033[0;31m'
    CYAN = '\033[0;36m'
    NC = '\033[0m'  # No Color

def print_banner():
    print(f"{Colors.CYAN}")
    print("╔════════════════════════════════════════════════════════════╗")
    print("║  DoodleDuet CasaOS App - Complete Build & Deploy          ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print(f"{Colors.NC}")

def print_step(msg: str):
    print(f"{Colors.BLUE}▶ {msg}{Colors.NC}")

def print_success(msg: str):
    print(f"{Colors.GREEN}✓ {msg}{Colors.NC}")

def print_warning(msg: str):
    print(f"{Colors.YELLOW}⚠ {msg}{Colors.NC}")

def print_error(msg: str):
    print(f"{Colors.RED}✗ {msg}{Colors.NC}")

def run_command(cmd: list, description: str = "", capture_output: bool = False) -> Tuple[int, str]:
    """Run a shell command and return exit code and output"""
    try:
        if description:
            print_step(description)
        
        if capture_output:
            result = subprocess.run(cmd, capture_output=True, text=True, check=False)
            return result.returncode, result.stdout.strip()
        else:
            return subprocess.run(cmd, check=False).returncode, ""
    except Exception as e:
        print_error(f"Failed to run command: {e}")
        return 1, ""

def get_github_username(github_token: str) -> Optional[str]:
    """Get GitHub username from token using GitHub API"""
    import urllib.request
    import urllib.error
    
    try:
        req = urllib.request.Request(
            'https://api.github.com/user',
            headers={'Authorization': f'token {github_token}'}
        )
        with urllib.request.urlopen(req, timeout=5) as response:
            data = json.loads(response.read())
            return data.get('login')
    except Exception as e:
        print_warning(f"Could not fetch GitHub username: {e}")
        return None

def generate_icon() -> bool:
    """Generate the app icon"""
    print_step("Generating DoodleDuet icon...")
    ret, _ = run_command(['python3', 'generate_icon.py'], "")
    if ret == 0:
        print_success(f"Icon generated: {APP_DIR}/icon.png")
        return True
    else:
        print_error("Failed to generate icon")
        return False

def validate_config() -> bool:
    """Validate docker-compose.yml and store.json"""
    print_step("Validating configuration...")
    
    # Check docker-compose.yml exists
    compose_file = APP_DIR / "docker-compose.yml"
    if not compose_file.exists():
        print_error(f"docker-compose.yml not found: {compose_file}")
        return False
    
    # Validate JSON
    if STORE_JSON.exists():
        try:
            with open(STORE_JSON) as f:
                json.load(f)
            print_success("store.json is valid JSON")
        except json.JSONDecodeError as e:
            print_error(f"Invalid JSON in store.json: {e}")
            return False
    
    # Test docker-compose config
    ret, output = run_command(
        ['docker', 'compose', '-f', str(compose_file), 'config'],
        "",
        capture_output=True
    )
    
    if ret == 0:
        print_success("docker-compose configuration is valid")
        return True
    else:
        print_warning(f"docker-compose validation warning: {output}")
        return True  # Continue anyway

def build_docker_image(github_username: str, github_token: str) -> Tuple[bool, str]:
    """Build Docker image and push to GitHub Container Registry"""
    print_step("Building and pushing Docker image...")
    
    # Construct image name
    image_name = f"{GHCR_IMAGE_BASE}/{github_username.lower()}/doodleduet-app"
    image_tag = "v1.0.0"
    full_image = f"{image_name}:{image_tag}"
    
    print(f"  Target image: {full_image}")
    
    # Check if Docker is running
    ret, _ = run_command(['docker', 'ps'], "", capture_output=True)
    if ret != 0:
        print_error("Docker is not running")
        return False, ""
    
    # Pull the original image
    print_step(f"Pulling base image: {DOCKER_IMAGE_ORIGINAL}")
    ret, _ = run_command(['docker', 'pull', DOCKER_IMAGE_ORIGINAL], "")
    if ret != 0:
        print_warning("Could not pull image (may still work with local cache)")
    
    # Tag the image for GHCR
    print_step(f"Tagging image as {full_image}")
    ret, _ = run_command(['docker', 'tag', DOCKER_IMAGE_ORIGINAL, full_image], "")
    if ret != 0:
        print_error("Failed to tag Docker image")
        return False, ""
    
    print_success(f"Image tagged: {full_image}")
    
    # Login to GHCR
    print_step("Authenticating with GitHub Container Registry...")
    try:
        # Use Docker API to avoid shell escaping issues on Windows
        import base64
        auth_string = base64.b64encode(f"{github_username}:{github_token}".encode()).decode()
        result = subprocess.run(
            ['docker', 'login', 'ghcr.io', '-u', github_username, '-p', github_token],
            capture_output=True,
            text=True,
            check=False
        )
        if result.returncode != 0:
            print_error("Failed to authenticate with GitHub Container Registry")
            return False, ""
    except Exception as e:
        print_error(f"Docker login failed: {e}")
        return False, ""
    
    # Push image
    print_step(f"Pushing image to {full_image}")
    ret, _ = run_command(['docker', 'push', full_image], "")
    if ret != 0:
        print_error("Failed to push image to GitHub Container Registry")
        return False, ""
    
    print_success(f"Image pushed: {full_image}")
    return True, full_image

def update_store_json(image_url: str) -> bool:
    """Update store.json with new image reference"""
    print_step("Updating store.json with new image reference...")
    
    if not STORE_JSON.exists():
        print_warning("store.json not found, creating template")
        store_data = {
            "name": "JoshEvans-Weber's Personal Store",
            "category_list": [
                {"name": "Games", "font": "gamepad"},
                {"name": "Utilities", "font": "wrench"}
            ],
            "recommend": ["vintagestory-custom"],
            "apps": []
        }
    else:
        try:
            with open(STORE_JSON) as f:
                store_data = json.load(f)
        except json.JSONDecodeError as e:
            print_error(f"Failed to parse store.json: {e}")
            return False
    
    # Check if app entry exists
    apps = store_data.get('apps', [])
    app_entry = None
    app_index = None
    
    for idx, app in enumerate(apps):
        if app.get('name') == APP_NAME:
            app_entry = app
            app_index = idx
            break
    
    if app_entry is None:
        # Create new entry
        print_step("Creating new app entry in store.json")
        app_entry = {
            "name": APP_NAME,
            "title": {"en_us": "DoodleDuet"},
            "icon": f"https://raw.githubusercontent.com/JoshEvans-Weber/casaos-store/main/Apps/{APP_NAME}/icon.png",
            "tagline": {"en_us": "Real-time collaborative drawing application with live chat"},
            "description": {"en_us": "DoodleDuet is a real-time collaborative drawing application. Draw together, chat in real-time, and create amazing artwork with friends!"},
            "category": "Games",
            "version": "1.0.0",
            "updated": datetime.now().isoformat(),
            "image": {"amd64": image_url}
        }
        apps.append(app_entry)
        print_success("New app entry created")
    else:
        # Update existing entry
        print_step("Updating existing app entry")
        app_entry['image'] = {"amd64": image_url}
        app_entry['updated'] = datetime.now().isoformat()
        apps[app_index] = app_entry
        print_success("App entry updated")
    
    # Save updated store.json
    store_data['apps'] = apps
    try:
        with open(STORE_JSON, 'w') as f:
            json.dump(store_data, f, indent=2)
        print_success(f"store.json updated with image: {image_url}")
        return True
    except Exception as e:
        print_error(f"Failed to write store.json: {e}")
        return False

def commit_and_push(github_username: str) -> bool:
    """Commit changes and push to GitHub"""
    print_step("Committing and pushing to GitHub...")
    
    # Check git status
    ret, status = run_command(['git', 'status', '--porcelain'], "", capture_output=True)
    if ret != 0:
        print_error("Not a git repository or git error")
        return False
    
    if not status:
        print_warning("No changes to commit")
        return True
    
    # Stage files
    run_command(['git', 'add', 'Apps/doodleduet-app/', 'store.json'], "")
    print_success("Files staged")
    
    # Create commit
    commit_msg = f"""Add/Update DoodleDuet collaborative drawing app

- DoodleDuet: Real-time collaborative drawing with Socket.IO and Redis
- Supports multiple users drawing simultaneously in shared rooms
- Features: Live chat, admin controls, infinite canvas with pan/zoom
- Includes Redis sidecar for real-time data synchronization
- Docker image: ghcr.io/{github_username.lower()}/doodleduet-app:v1.0.0
- Follows CasaOS appstore standards and conventions
- Automated build and deployment"""
    
    ret, _ = run_command(['git', 'commit', '-m', commit_msg], "")
    if ret != 0:
        print_warning("Commit failed or nothing to commit")
        return True
    
    print_success("Commit created")
    
    # Push to GitHub
    ret, _ = run_command(['git', 'push'], "")
    if ret != 0:
        print_error("Failed to push to GitHub")
        return False
    
    print_success("Pushed to GitHub")
    return True

def verify_deployment() -> bool:
    """Verify the deployment"""
    print_step("Verifying deployment...")
    
    # Check files exist
    required_files = [
        APP_DIR / "docker-compose.yml",
        APP_DIR / "README.md",
        APP_DIR / "icon.png"
    ]
    
    missing = []
    for file in required_files:
        if file.exists():
            print_success(f"Found: {file}")
        else:
            missing.append(str(file))
    
    if missing:
        print_error(f"Missing files: {', '.join(missing)}")
        return False
    
    # Check store.json has the entry
    if STORE_JSON.exists():
        try:
            with open(STORE_JSON) as f:
                store_data = json.load(f)
            
            apps = store_data.get('apps', [])
            if any(app.get('name') == APP_NAME for app in apps):
                print_success("App entry found in store.json")
            else:
                print_warning("App entry not found in store.json")
                return False
        except Exception as e:
            print_error(f"Error reading store.json: {e}")
            return False
    
    return True

def main():
    parser = argparse.ArgumentParser(
        description="DoodleDuet CasaOS App - Automated Build & Deploy"
    )
    parser.add_argument(
        '--token',
        type=str,
        help='GitHub Personal Access Token (or set GITHUB_TOKEN env var)'
    )
    parser.add_argument(
        '--username',
        type=str,
        help='GitHub username (optional, will be fetched from API if not provided)'
    )
    parser.add_argument(
        '--skip-docker',
        action='store_true',
        help='Skip Docker build/push (useful for testing)'
    )
    parser.add_argument(
        '--skip-git',
        action='store_true',
        help='Skip git commit/push'
    )
    
    args = parser.parse_args()
    
    print_banner()
    
    # Get GitHub token
    github_token = args.token or os.getenv('GITHUB_TOKEN')
    if not github_token:
        print_error("GitHub token required!")
        print("  Provide via: --token <token> or GITHUB_TOKEN environment variable")
        return False
    
    # Get GitHub username
    print_step("Authenticating with GitHub...")
    
    # Try to use provided username first
    if args.username:
        github_username = args.username
        print_success(f"Using GitHub username: {github_username}")
    else:
        # Try to fetch from API
        github_username = get_github_username(github_token)
        if not github_username:
            print_warning("Could not fetch username from API, trying to fetch from git config...")
            ret, username = run_command(['git', 'config', '--global', 'user.name'], "", capture_output=True)
            if ret == 0 and username:
                github_username = username
                print_success(f"Using GitHub username from git config: {github_username}")
            else:
                print_error("Could not determine GitHub username. Provide via: --username <username>")
                return False
        else:
            print_success(f"Authenticated as: {github_username}")
    
    # Step 1: Generate icon
    if not generate_icon():
        return False
    
    # Step 2: Validate configuration
    if not validate_config():
        return False
    
    # Step 3: Build and push Docker image
    if not args.skip_docker:
        success, image_url = build_docker_image(github_username, github_token)
        if not success:
            return False
    else:
        print_warning("Skipping Docker build/push")
        image_url = f"ghcr.io/{github_username.lower()}/doodleduet-app:v1.0.0"
    
    # Step 4: Update store.json
    if not update_store_json(image_url):
        return False
    
    # Step 5: Commit and push
    if not args.skip_git:
        if not commit_and_push(github_username):
            return False
    else:
        print_warning("Skipping git commit/push")
    
    # Step 6: Verify deployment
    if not verify_deployment():
        return False
    
    # Success!
    print("")
    print(f"{Colors.GREEN}{'═' * 62}{Colors.NC}")
    print(f"{Colors.GREEN}✓ DoodleDuet app successfully deployed!{Colors.NC}")
    print(f"{Colors.GREEN}{'═' * 62}{Colors.NC}")
    print("")
    print("Next steps:")
    print(f"1. In CasaOS, go to App Store")
    print(f"2. Click 'Refresh' to pull latest apps")
    print(f"3. Search for 'DoodleDuet'")
    print(f"4. Click 'Install' and test the app")
    print("")
    print(f"App image: {image_url}")
    print("")
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
