$imageName = "pokecentral"
$ghcrUser = "joshevans-weber"
$version = "1.0.0"
$tag = "ghcr.io/$ghcrUser/$imageName`:$version"
$latest = "ghcr.io/$ghcrUser/$imageName`:latest"

Write-Host "Building PokeCentral Docker image..." -ForegroundColor Cyan
Write-Host "Tag: $tag" -ForegroundColor Gray

# Build
Write-Host "Building..." -NoNewline
docker build -t $tag -t $latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host " FAILED" -ForegroundColor Red
    exit 1
}
Write-Host " Done" -ForegroundColor Green

# Push version tag
Write-Host "Pushing $tag..." -NoNewline
docker push $tag | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host " FAILED" -ForegroundColor Red
    exit 1
}
Write-Host " Done" -ForegroundColor Green

# Push latest tag
Write-Host "Pushing $latest..." -NoNewline
docker push $latest | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host " FAILED" -ForegroundColor Red
    exit 1
}
Write-Host " Done" -ForegroundColor Green

Write-Host "`nPokeCentral v$version successfully built and pushed!" -ForegroundColor Green
