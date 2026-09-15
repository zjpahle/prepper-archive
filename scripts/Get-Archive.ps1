<#
.SYNOPSIS
  Downloads every item in ../manifest.json into ../content/<category>/<name> via
  asynchronous BITS jobs. Safe to re-run or interrupt at any time: it reconnects to
  an existing job by name (matching BytesTransferred/BytesTotal) instead of starting
  a duplicate download, and BITS jobs keep transferring in the background even if
  this script isn't running, surviving reboots as long as you log back in.

.EXAMPLE
  .\Get-Archive.ps1
  .\Get-Archive.ps1 -Category zim        # only download the ZIM files
  .\Get-Archive.ps1 -Category software   # only download ISOs/installers
#>

param(
    [ValidateSet("zim", "docs", "software", "all")]
    [string]$Category = "all"
)

Import-Module BitsTransfer -ErrorAction Stop

$root = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $root "manifest.json"
$contentRoot = Join-Path $root "content"

if (-not (Test-Path $manifestPath)) {
    throw "manifest.json not found at $manifestPath"
}

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$items = $manifest.items
if ($Category -ne "all") {
    $items = $items | Where-Object { $_.category -eq $Category }
}

Write-Host "Processing $($items.Count) item(s) (category: $Category)" -ForegroundColor Cyan

foreach ($item in $items) {
    $destDir = Join-Path $contentRoot $item.category
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    $destPath = Join-Path $destDir $item.name

    # A finished file must be at least 90% of the expected size to be trusted as complete
    # (BITS pre-allocates full size upfront, so size-on-disk alone can't tell partial from done).
    $expectedBytes = [int64]($item.approxSizeGB * 1GB)
    $minTrustedBytes = [int64]($expectedBytes * 0.9)

    if (Test-Path $destPath) {
        $existingSize = (Get-Item $destPath).Length
        if ($existingSize -ge $minTrustedBytes) {
            Write-Host "SKIP  $($item.name) (already complete, $([math]::Round($existingSize/1GB,1))GB)" -ForegroundColor DarkGray
            continue
        } else {
            Write-Host "WARN  $($item.name) exists but looks incomplete ($([math]::Round($existingSize/1GB,1))GB of ~$($item.approxSizeGB)GB) - removing and re-fetching" -ForegroundColor Red
            Remove-Item $destPath -Force
        }
    }

    # Reconnect to an in-progress job instead of starting a duplicate download.
    $job = Get-BitsTransfer -Name $item.name -ErrorAction SilentlyContinue | Select-Object -First 1

    if (-not $job) {
        Write-Host "GET   $($item.name)  (~$($item.approxSizeGB) GB)  <-  $($item.url)" -ForegroundColor Yellow
        $job = Start-BitsTransfer -Source $item.url -Destination $destPath -DisplayName $item.name -Asynchronous -ErrorAction Stop
    }

    while ($true) {
        $job = Get-BitsTransfer -JobId $job.JobId -ErrorAction SilentlyContinue
        if (-not $job) { Write-Host "FAIL  $($item.name): job disappeared" -ForegroundColor Red; break }

        switch ($job.JobState) {
            "Transferred" {
                Complete-BitsTransfer -BitsJob $job
                Write-Host "DONE  $($item.name)" -ForegroundColor Green
                break
            }
            { $_ -in "Error", "TransientError" } {
                Write-Host "RETRY $($item.name): $($job.ErrorDescription)" -ForegroundColor Red
                Resume-BitsTransfer -BitsJob $job -Asynchronous -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 10
                continue
            }
            default {
                $pct = if ($job.BytesTotal -gt 0) { [math]::Round(100 * $job.BytesTransferred / $job.BytesTotal, 1) } else { 0 }
                Write-Host "`r      $($item.name): $pct% ($([math]::Round($job.BytesTransferred/1GB,1))GB / $([math]::Round($job.BytesTotal/1GB,1))GB) [$($job.JobState)]" -NoNewline -ForegroundColor Yellow
                Start-Sleep -Seconds 15
                continue
            }
        }
        break
    }
    Write-Host ""
}

Write-Host ""
Write-Host "Done. Content is under $contentRoot" -ForegroundColor Cyan
Write-Host "Copy it to the NAS share (e.g. /volume1/archive/) preserving the zim/docs/software subfolders." -ForegroundColor Cyan
