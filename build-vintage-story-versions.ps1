#!/usr/bin/env powershell

# Build and deploy Vintage Story server versions
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
$imageName = "vintagestory-server"
$buildDir = "C:\temp\vintage-story-builds"
$dockerLoginUsername = "JoshEvans-Weber"

# Ensure build directory exists
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

Write-Host "Building Vintage Story server Docker images..." -ForegroundColor Green
Write-Host "Versions to build: $($versions -join ', ')"
Write-Host ""

foreach ($version in $versions) {
    $versionClean = $version -replace '\.' , '-'
    $url = "https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_$version.tar.gz"
    $fileName = "vs_server_linux-x64_$version.tar.gz"
    $downloadPath = Join-Path $buildDir $fileName
    $extractPath = Join-Path $buildDir "vs_$versionClean"
    $dockerImageTag = "ghcr.io/$ghcrUser/$imageName`:$version"
    
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "Building version $version" -ForegroundColor Yellow
    Write-Host "======================================"
    
    # Download
    if (Test-Path $downloadPath) {
        Write-Host "✓ Already downloaded: $fileName" -ForegroundColor Green
    } else {
        Write-Host "Downloading $fileName..." -ForegroundColor Blue
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri $url -OutFile $downloadPath -TimeoutSec 600
            Write-Host "✓ Downloaded successfully" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to download: $_" -ForegroundColor Red
            continue
        }
    }
    
    # Extract
    if (Test-Path $extractPath) {
        Write-Host "✓ Already extracted" -ForegroundColor Green
    } else {
        Write-Host "Extracting archive..." -ForegroundColor Blue
        try {
            tar -xzf $downloadPath -C $buildDir
            if (Test-Path (Join-Path $buildDir "vs_server")) {
                Rename-Item -Path (Join-Path $buildDir "vs_server") -NewName "vs_$versionClean" -Force
            }
            Write-Host "✓ Extracted successfully" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to extract: $_" -ForegroundColor Red
            continue
        }
    }
    
    # Check for Dockerfile
    $dockerfilePath = Join-Path $extractPath "Dockerfile"
    if (-not (Test-Path $dockerfilePath)) {
        # Create a Dockerfile if it doesn't exist
        $dockerfileContent = @"
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y libstdc++6 libssl3 && rm -rf /var/lib/apt/lists/*

WORKDIR /vintagestory
COPY . /vintagestory/

# Create data directory
RUN mkdir -p /vintagestory/data

EXPOSE 42420/udp 7681/tcp 5000/tcp

VOLUME ["/vintagestory/data"]

CMD ["./VintageStory", "--dataPath", "/vintagestory/data"]
"@
        Set-Content -Path $dockerfilePath -Value $dockerfileContent -Encoding UTF8
        Write-Host "✓ Created Dockerfile" -ForegroundColor Green
    }
    
    # Build Docker image
    Write-Host "Building Docker image: $dockerImageTag" -ForegroundColor Blue
    try {
        & docker build -t $dockerImageTag -f $dockerfilePath $extractPath
        Write-Host "✓ Built successfully" -ForegroundColor Green
    } catch {
        Write-Host "✗ Build failed: $_" -ForegroundColor Red
        continue
    }
    
    # Push to GHCR
    Write-Host "Pushing to GHCR: $dockerImageTag" -ForegroundColor Blue
    try {
        & docker push $dockerImageTag
        Write-Host "✓ Pushed successfully" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Push failed: $_" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Build process complete!" -ForegroundColor Green
Write-Host "======================================"
Write-Host ""
Write-Host "Built images:" -ForegroundColor Yellow
foreach ($version in $versions) {
    Write-Host "  - ghcr.io/$ghcrUser/$imageName`:$version"
}
