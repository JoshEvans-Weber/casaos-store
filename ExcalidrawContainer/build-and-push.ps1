#!/usr/bin/env pwsh
<#
.SYNOPSIS
Build and push Excalidraw Docker image to GitHub Container Registry

.DESCRIPTION
Builds the Excalidraw Docker image and pushes it to GHCR with both 'latest' and version tags

.EXAMPLE
./build-and-push.ps1
#>

param(
    [string]$Version = "1.0.0",
    [string]$Registry = "ghcr.io/joshevans-weber",
    [string]$ImageName = "excalidraw"
)

$ErrorActionPreference = "Stop"

# Build the image
Write-Host "Building Excalidraw image..." -ForegroundColor Cyan
$FullImageName = "$Registry/$ImageName"

docker build -t "$FullImageName:latest" -t "$FullImageName:$Version" .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build successful!" -ForegroundColor Green

# Push to registry
Write-Host "Pushing to GitHub Container Registry..." -ForegroundColor Cyan

docker push "$FullImageName:latest"
docker push "$FullImageName:$Version"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Push failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Push successful!" -ForegroundColor Green
Write-Host ""
Write-Host "Image pushed:" -ForegroundColor Cyan
Write-Host "  $FullImageName`:latest"
Write-Host "  $FullImageName`:$Version"
