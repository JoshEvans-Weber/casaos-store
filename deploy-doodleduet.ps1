# DoodleDuet CasaOS App - Windows Deployment Script
# Automates: Icon generation, Docker build/push, store.json update, git commit/push

param(
    [string]$GitHubToken = $env:GITHUB_TOKEN,
    [switch]$SkipDocker,
    [switch]$SkipGit,
    [switch]$Help
)

# Banner
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  DoodleDuet CasaOS App - Complete Build & Deploy          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($Help) {
    Write-Host "Usage: .\deploy-doodleduet.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -GitHubToken <token>   GitHub Personal Access Token (or set GITHUB_TOKEN env var)"
    Write-Host "  -SkipDocker            Skip Docker build/push"
    Write-Host "  -SkipGit               Skip git commit/push"
    Write-Host "  -Help                  Show this help message"
    Write-Host ""
    exit 0
}

# Check prerequisites
Write-Host "▶ Checking prerequisites..." -ForegroundColor Blue
$prerequisites = @('python3', 'docker', 'git')
$missing = @()

foreach ($cmd in $prerequisites) {
    try {
        $null = & $cmd --version 2>&1
        Write-Host "✓ $cmd" -ForegroundColor Green
    } catch {
        $missing += $cmd
    }
}

if ($missing.Count -gt 0) {
    Write-Host "✗ Missing prerequisites: $($missing -join ', ')" -ForegroundColor Red
    exit 1
}

# Check GitHub token
if (-not $GitHubToken) {
    Write-Host "✗ GitHub token required!" -ForegroundColor Red
    Write-Host "  Provide via: -GitHubToken <token> or GITHUB_TOKEN environment variable"
    exit 1
}

# Run Python deployment script
Write-Host ""
Write-Host "▶ Running automated deployment..." -ForegroundColor Blue
Write-Host ""

$deployArgs = @('deploy-doodleduet.py')

if ($SkipDocker) {
    $deployArgs += '--skip-docker'
}

if ($SkipGit) {
    $deployArgs += '--skip-git'
}

$deployArgs += '--token', $GitHubToken

& python3 @deployArgs
$exitCode = $LASTEXITCODE

exit $exitCode
