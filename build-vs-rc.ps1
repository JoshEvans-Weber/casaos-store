$versions = @("1.22.0-rc.7","1.22.0-rc.6","1.22.0-rc.5","1.22.0-rc.4","1.22.0-rc.3","1.22.0-rc.2")
$buildDir = "C:\temp\vintage-story-builds"
$ghcrUser = "joshevans-weber"
$imageName = "vintagestory-server"

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

foreach ($version in $versions) {
    $safe = $version -replace '\.', '-'
    $url = "https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_$version.tar.gz"
    $dlPath = "$buildDir\vs_$safe.tar.gz"
    $exPath = "$buildDir\vs_$safe"
    $tempEx = "$buildDir\temp_$safe"
    $tag = "ghcr.io/$ghcrUser/$imageName`:$version"
    
    Write-Host "`n=== Building $version ===" -ForegroundColor Cyan
    
    if (-not (Test-Path $dlPath)) {
        Write-Host "Downloading..." -NoNewline
        Invoke-WebRequest -Uri $url -OutFile $dlPath -TimeoutSec 600 -ErrorAction Stop
        Write-Host " Done" -ForegroundColor Green
    } else {
        Write-Host "Already downloaded" -ForegroundColor Green
    }
    
    if (-not (Test-Path $exPath)) {
        Write-Host "Extracting..." -NoNewline
        Remove-Item -Path $tempEx -Recurse -Force -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Path $tempEx -Force | Out-Null
        tar -xzf $dlPath -C $tempEx
        $extracted = Get-ChildItem -Path $tempEx -ErrorAction SilentlyContinue
        if ($extracted -and $extracted.Count -eq 1 -and $extracted[0].PSIsContainer) {
            Move-Item -Path "$tempEx\$($extracted[0].Name)" -Destination $exPath -Force
        } else {
            Move-Item -Path "$tempEx\*" -Destination $exPath -Force
        }
        Remove-Item -Path $tempEx -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host " Done" -ForegroundColor Green
    } else {
        Write-Host "Already extracted" -ForegroundColor Green
    }
    
    $dfile = "$exPath\Dockerfile"
    if (-not (Test-Path $dfile)) {
        Write-Host "Creating Dockerfile..." -NoNewline
        $lines = @(
            "FROM ubuntu:22.04",
            "RUN apt-get update && apt-get install -y libstdc++6 libssl3 && rm -rf /var/lib/apt/lists/*",
            "WORKDIR /vintagestory",
            "COPY . /vintagestory/",
            "RUN mkdir -p /vintagestory/data",
            "EXPOSE 42420/udp 7681/tcp 5000/tcp",
            'VOLUME ["/vintagestory/data"]',
            'CMD ["./VintageStory", "--dataPath", "/vintagestory/data"]'
        )
        [System.IO.File]::WriteAllLines($dfile, $lines)
        Write-Host " Done" -ForegroundColor Green
    }
    
    Write-Host "Building image..." -NoNewline
    docker build -t $tag -f $dfile $exPath | Out-Null
    Write-Host " Done" -ForegroundColor Green
    
    Write-Host "Pushing to GHCR..." -NoNewline
    docker push $tag | Out-Null
    Write-Host " Done" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "All RC versions complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
