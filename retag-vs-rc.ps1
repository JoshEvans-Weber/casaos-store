$versions = @("1.22.0-rc.7","1.22.0-rc.6","1.22.0-rc.5","1.22.0-rc.4","1.22.0-rc.3","1.22.0-rc.2")
$ghcrUser = "joshevans-weber"
$srcImage = "vintagestory-server"
$dstImage = "vintagestory-custom-rc"

Write-Host "Re-tagging and pushing Vintage Story RC images..." -ForegroundColor Green

foreach ($version in $versions) {
    $srcTag = "ghcr.io/$ghcrUser/$srcImage`:$version"
    $dstTag = "ghcr.io/$ghcrUser/$dstImage`:$version"
    
    Write-Host "`nRe-tagging $version..." -NoNewline
    docker tag $srcTag $dstTag
    Write-Host " Done" -ForegroundColor Green
    
    Write-Host "Pushing $dstTag..." -NoNewline
    docker push $dstTag | Out-Null
    Write-Host " Done" -ForegroundColor Green
}

# Tag latest as rc.7
$latestSrc = "ghcr.io/$ghcrUser/$srcImage`:1.22.0-rc.7"
$latestDst = "ghcr.io/$ghcrUser/$dstImage`:latest"
Write-Host "`nTagging latest..." -NoNewline
docker tag $latestSrc $latestDst
Write-Host " Done" -ForegroundColor Green

Write-Host "Pushing latest tag..." -NoNewline
docker push $latestDst | Out-Null
Write-Host " Done" -ForegroundColor Green

Write-Host "`nAll RC versions re-tagged and pushed!" -ForegroundColor Green
