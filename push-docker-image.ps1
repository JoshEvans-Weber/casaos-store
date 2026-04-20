#!/usr/bin/env pwsh
<#
.SYNOPSIS
Push DoodleDuet Docker image to GitHub Container Registry

.PARAMETER GitHubToken
GitHub personal access token with write:packages scope

.EXAMPLE
.\push-docker-image.ps1 -GitHubToken "ghp_xxxxxxxxxxxx"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubToken,
    
    [string]$GitHubUsername = "JoshEvans-Weber",
    [string]$ImageBase = "aiyuayaan/doodleduet-app",
    [string]$ImageTag = "v1.0.0",
    [string]$RegistryUrl = "ghcr.io"
)

$ErrorActionPreference = "Stop"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DoodleDuet Docker - GHCR Push" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Docker
Write-Host ">> Checking Docker..." -ForegroundColor Blue
try {
    docker ps > $null 2>&1
    Write-Host "OK Docker is running" -ForegroundColor Green
} catch {
    Write-Host "ERROR Docker is not running" -ForegroundColor Red
    exit 1
}

# Step 2: Pull base image
Write-Host ">> Pulling base image: $ImageBase`:$ImageTag" -ForegroundColor Blue
docker pull "$ImageBase`:$ImageTag"
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING Could not pull image" -ForegroundColor Yellow
}

# Step 3: Tag for GHCR
$TargetImage = "$RegistryUrl/$($GitHubUsername.ToLower())/doodleduet-app:$ImageTag"
Write-Host ">> Tagging image as: $TargetImage" -ForegroundColor Blue
docker tag "$ImageBase`:$ImageTag" $TargetImage
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR Failed to tag image" -ForegroundColor Red
    exit 1
}
Write-Host "OK Image tagged" -ForegroundColor Green

# Step 4: Login to GHCR
Write-Host ">> Authenticating with GitHub Container Registry..." -ForegroundColor Blue
docker login $RegistryUrl -u $GitHubUsername -p $GitHubToken
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR Failed to authenticate" -ForegroundColor Red
    Write-Host "  Check token has write:packages scope" -ForegroundColor Yellow
    exit 1
}
Write-Host "OK Authentication successful" -ForegroundColor Green

# Step 5: Push image
Write-Host ">> Pushing image..." -ForegroundColor Blue
docker push $TargetImage
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR Failed to push image" -ForegroundColor Red
    exit 1
}
Write-Host "OK Image pushed" -ForegroundColor Green

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "SUCCESS Docker image pushed to GHCR!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub Packages:" -ForegroundColor Cyan
Write-Host "  https://github.com/$GitHubUsername/packages" -ForegroundColor White
Write-Host ""
Write-Host "Image URL:" -ForegroundColor Cyan
Write-Host "  $TargetImage" -ForegroundColor White
Write-Host ""
