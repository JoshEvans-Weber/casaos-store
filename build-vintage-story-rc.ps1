#!/usr/bin/env powershell

# Build and deploy Vintage Story RC server versions
# Downloads, extracts, builds Docker images, and pushes to GHCR

$versions = @(
    "1.22.0-rc.7",
    "1.22.0-rc.6",
    "1.22.0-rc.5",
    "1.22.0-rc.4",
    "1.22.0-rc.3",
    "1.22.0-rc.2"
)

$ghcrUser = "joshevans-weber"
$imageName = "vintagestory-server-rc"
$buildDir = "C:\temp\vintage-story-rc-builds"
$dockerLoginUsername = "JoshEvans-Weber"

# Ensure build directory exists
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

Write-Host "Building Vintage Story server Docker images (RC versions)..." -ForegroundColor Cyan
Write-Host "Versions to build: $($versions -join ', ')"
Write-Host ""

# Check docker login
Write-Host "Checking Docker authentication..." -ForegroundColor Blue
$envPath = Join-Path $PSScriptRoot ".env.local"
if (Test-Path $envPath) {
    $token = (Get-Content $envPath | Select-String "GITHUB_TOKEN" | ForEach-Object {$_ -split '=' | Select-Object -Last 1}).Trim()
    if ($token) {
        Write-Host "Using GitHub token from .env.local" -ForegroundColor Green
        try {
            $token | docker login ghcr.io -u $dockerLoginUsername --password-stdin | Out-Null
            Write-Host "[OK] Authenticated to GHCR" -ForegroundColor Green
        }
        catch {
            Write-Host "[WARN] Docker login failed: $_" -ForegroundColor Yellow
        }
    }
}

foreach ($version in $versions) {
    $dockerImageTag = "ghcr.io/$ghcrUser/$imageName`:$version"
    $url = "https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_$version.tar.gz"
    $fileName = "vs_server_linux-x64_$version.tar.gz"
    $downloadPath = Join-Path $buildDir $fileName
    $extractPath = Join-Path $buildDir "vs_rc_$version"
    
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "Building RC version $version" -ForegroundColor Yellow
    Write-Host "Image: $dockerImageTag" -ForegroundColor Gray
    Write-Host "======================================"
    
    # Download
    if (Test-Path $downloadPath) {
        Write-Host "[OK] Already downloaded: $fileName" -ForegroundColor Green
    } else {
        Write-Host "Downloading $fileName..." -ForegroundColor Blue
        try {
            Invoke-WebRequest -Uri $url -OutFile $downloadPath -TimeoutSec 300
            Write-Host "[OK] Downloaded successfully" -ForegroundColor Green
        }
        catch {
            Write-Host "[FAIL] Failed to download: $_" -ForegroundColor Red
            continue
        }
    }
    
    # Extract
    if (Test-Path $extractPath) {
        Write-Host "[OK] Already extracted" -ForegroundColor Green
    } else {
        Write-Host "Extracting archive..." -ForegroundColor Blue
        try {
            New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
            tar -xzf $downloadPath -C $extractPath
            Write-Host "[OK] Extracted successfully" -ForegroundColor Green
        }
        catch {
            Write-Host "[FAIL] Failed to extract: $_" -ForegroundColor Red
            continue
        }
    }
    
    # Create Dockerfile
    $dockerfilePath = Join-Path $extractPath "Dockerfile"
    $dockerfileContent = @'
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y libstdc++6 libssl3 && rm -rf /var/lib/apt/lists/*

WORKDIR /vintagestory
COPY . /vintagestory/

RUN mkdir -p /vintagestory/data && chmod +x /vintagestory/VintageStory

EXPOSE 42420/udp 7681/tcp 5000/tcp

VOLUME ["/vintagestory/data"]

CMD ["./VintageStory", "--dataPath", "/vintagestory/data"]
'@
    Set-Content -Path $dockerfilePath -Value $dockerfileContent
    Write-Host "[OK] Created Dockerfile" -ForegroundColor Green
    
    # Build Docker image
    Write-Host "Building Docker image..." -ForegroundColor Blue
    try {
        docker build -t $dockerImageTag -f $dockerfilePath $extractPath | Out-Null
        Write-Host "[OK] Built successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "[FAIL] Build failed: $_" -ForegroundColor Red
        continue
    }
    
    # Push to GHCR
    Write-Host "Pushing to GHCR..." -ForegroundColor Blue
    try {
        docker push $dockerImageTag | Out-Null
        Write-Host "[OK] Pushed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "[WARN] Push failed: $_" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Build process complete!" -ForegroundColor Green
Write-Host "======================================"
Write-Host ""
Write-Host "Built and pushed images:"
foreach ($version in $versions) {
    Write-Host "  - ghcr.io/$ghcrUser/$imageName`:$version" -ForegroundColor Green
}
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Create docker-compose.yml files for each RC in Apps/"
Write-Host "2. Add entries to store.json"
Write-Host "3. Commit and push to GitHub"
