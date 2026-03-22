# DoodleDuet CasaOS App Build & Deploy Script (Windows PowerShell)
# Handles icon generation, validation, testing, and GitHub deployment

param(
    [switch]$SkipGit = $false,
    [switch]$Force = $false
)

# Configuration
$AppName = "doodleduet-app"
$AppDir = "Apps\$AppName"
$StoreJson = "store.json"
$DockerImage = "aiyuayaan/doodleduet-app:v1.0.0"
$GithubRepo = "JoshEvans-Weber/casaos-store"

# Color output helpers
function Write-Banner {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║    DoodleDuet CasaOS App Build & Deploy (Windows)         ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host "▶ $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Test-CommandExists {
    param([string]$Command)
    $exists = $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
    if (-not $exists) {
        Write-Error-Custom "Command not found: $Command"
        exit 1
    }
}

# Main script
function Main {
    Write-Banner
    
    # Step 1: Check prerequisites
    Write-Step "Checking prerequisites..."
    Test-CommandExists "python"
    Test-CommandExists "docker"
    Test-CommandExists "git"
    Write-Success "All prerequisites installed"
    
    # Step 2: Generate icon
    Write-Step "Generating DoodleDuet icon..."
    if (python generate_icon.py) {
        Write-Success "Icon generated: $AppDir\icon.png"
    } else {
        Write-Error-Custom "Failed to generate icon"
        exit 1
    }
    
    # Step 3: Validate JSON format
    Write-Step "Validating store.json..."
    try {
        $jsonContent = Get-Content $StoreJson -Raw
        $null = $jsonContent | ConvertFrom-Json
        Write-Success "store.json is valid JSON"
    } catch {
        Write-Error-Custom "store.json has invalid JSON syntax: $_"
        exit 1
    }
    
    # Step 4: Check if app entry exists in store.json
    Write-Step "Checking store.json for app entry..."
    if ($jsonContent -match "\"name\": `"$AppName`"") {
        Write-Success "App entry found in store.json"
    } else {
        Write-Warning "App entry not found in store.json"
        Write-Warning "You need to manually add the entry from Apps\$AppName\store-entry.json"
    }
    
    # Step 5: Check icon file exists
    Write-Step "Verifying icon file..."
    if (Test-Path "$AppDir\icon.png") {
        $iconSize = (Get-Item "$AppDir\icon.png").Length / 1KB
        Write-Success "Icon file exists ($([Math]::Round($iconSize, 2))KB)"
    } else {
        Write-Error-Custom "Icon file not found: $AppDir\icon.png"
        exit 1
    }
    
    # Step 6: Verify file structure
    Write-Step "Verifying app file structure..."
    $requiredFiles = @(
        "docker-compose.yml",
        "README.md",
        "icon.png"
    )
    
    $missingFiles = @()
    foreach ($file in $requiredFiles) {
        $filePath = "$AppDir\$file"
        if (Test-Path $filePath) {
            Write-Success "Found: $filePath"
        } else {
            $missingFiles += $file
        }
    }
    
    if ($missingFiles.Count -gt 0) {
        Write-Error-Custom "Missing files: $($missingFiles -join ', ')"
        exit 1
    }
    
    # Step 7: Test docker-compose configuration
    Write-Step "Testing docker-compose configuration..."
    try {
        Push-Location $AppDir
        $dockerOutput = docker-compose config 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "docker-compose configuration is valid"
        } else {
            Write-Warning "docker-compose config validation failed: $dockerOutput"
        }
        Pop-Location
    } catch {
        Write-Warning "docker-compose validation skipped: $_"
    }
    
    # Step 8: Show summary and next steps
    Write-Step "Build preparation complete!"
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✓ DoodleDuet app is ready for deployment" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Next steps:"
    Write-Host "1. Verify store.json entry:"
    Write-Host "   $(Get-Content 'Apps\$AppName\store-entry.json' | Select-Object -First 5 | Out-String)"
    Write-Host ""
    Write-Host "2. Add to store.json if not already present:"
    Write-Host "   • Edit $StoreJson"
    Write-Host "   • Add entry from Apps\$AppName\store-entry.json to the apps array"
    Write-Host ""
    Write-Host "3. Commit and push to GitHub:"
    Write-Host "   git add Apps\$AppName\"
    Write-Host "   git commit -m 'Add DoodleDuet collaborative drawing app'"
    Write-Host "   git push"
    Write-Host ""
    Write-Host "4. Test in CasaOS:"
    Write-Host "   • Refresh your app store"
    Write-Host "   • Search for 'DoodleDuet'"
    Write-Host "   • Install and verify functionality"
    Write-Host ""
    
    # Step 9: Optional - Git operations
    if (-not $SkipGit) {
        $response = Read-Host "Do you want to commit and push to GitHub now? (y/n)"
        if ($response -eq 'y' -or $response -eq 'Y') {
            Deploy-ToGithub
        } else {
            Write-Warning "Remember to commit and push your changes manually"
        }
    }
}

function Deploy-ToGithub {
    Write-Step "Preparing GitHub deployment..."
    
    # Check git status
    try {
        $null = git rev-parse --git-dir 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Error-Custom "Not a git repository"
            return
        }
    } catch {
        Write-Error-Custom "Not a git repository"
        return
    }
    
    # Check for changes
    Write-Step "Checking for changes..."
    $gitStatus = git status --porcelain "$AppDir" 2>&1
    if ([string]::IsNullOrWhiteSpace($gitStatus)) {
        Write-Warning "No changes detected in $AppDir"
        return
    }
    
    # Stage files
    Write-Step "Adding files to git..."
    git add "$AppDir\"
    Write-Success "Files staged"
    
    # Create commit
    Write-Step "Creating commit..."
    $commitMsg = @"
Add DoodleDuet collaborative drawing app to CasaOS store

- DoodleDuet: Real-time collaborative drawing with Socket.IO and Redis
- Supports multiple users drawing simultaneously in shared rooms
- Features: Live chat, admin controls, infinite canvas with pan/zoom
- Includes Redis sidecar for real-time data synchronization
- Follows CasaOS appstore standards and conventions
"@
    
    if (git commit -m $commitMsg) {
        Write-Success "Commit created"
    } else {
        Write-Warning "Nothing to commit"
        return
    }
    
    # Push to GitHub
    Write-Step "Pushing to GitHub..."
    if (git push) {
        Write-Success "Successfully pushed to GitHub"
        $branch = git rev-parse --abbrev-ref HEAD
        $commit = git rev-parse --short HEAD
        Write-Host "  Repository: $GithubRepo"
        Write-Host "  Branch: $branch"
        Write-Host "  Commit: $commit"
    } else {
        Write-Error-Custom "Failed to push to GitHub. Push manually with: git push"
    }
}

# Run main script
try {
    Main
} catch {
    Write-Error-Custom "Script failed: $_"
    exit 1
}
