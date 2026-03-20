param(
    [string]$Repo = $(if ($env:REPO) { $env:REPO } else { "grahamlouis/MuTui-downloads" }),
    [string]$BinName = $(if ($env:BIN_NAME) { $env:BIN_NAME } else { "terminal-daw" }),
    [string]$InstallDir = $(if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA "MuTui\bin" }),
    [string]$Version = $(if ($env:VERSION) { $env:VERSION } else { "latest" })
)

$ErrorActionPreference = "Stop"

function Get-LatestVersion {
    param([string]$Repo)
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest"
    if (-not $release.tag_name) {
        throw "Failed to determine latest release for $Repo"
    }
    return $release.tag_name
}

function Get-WindowsTarget {
    $candidates = @()

    try {
        $runtimeArch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
        if ($null -ne $runtimeArch) {
            $candidates += $runtimeArch.ToString()
        }
    }
    catch {
    }

    if ($env:PROCESSOR_ARCHITEW6432) {
        $candidates += $env:PROCESSOR_ARCHITEW6432
    }
    if ($env:PROCESSOR_ARCHITECTURE) {
        $candidates += $env:PROCESSOR_ARCHITECTURE
    }

    $arch = ($candidates | Where-Object { $_ -and $_.Trim().Length -gt 0 } | Select-Object -First 1)
    $normalized = if ($arch) { $arch.Trim().ToUpperInvariant() } else { "" }

    switch -Regex ($normalized) {
        "^(X64|AMD64)$" {
            return "x86_64-pc-windows-msvc"
        }
        "^(ARM64|AARCH64)$" {
            Write-Warning "ARM64 Windows detected; installing the x86_64 build."
            return "x86_64-pc-windows-msvc"
        }
        default {
            throw "Unsupported Windows architecture: $normalized"
        }
    }
}

$target = Get-WindowsTarget

if ($Version -eq "latest") {
    $Version = Get-LatestVersion -Repo $Repo
}

$archive = "$BinName-$Version-$target.zip"
$url = "https://github.com/$Repo/releases/download/$Version/$archive"
$tmpdir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString("N"))

New-Item -ItemType Directory -Force -Path $tmpdir | Out-Null
try {
    Write-Host "Downloading $archive..."
    $archivePath = Join-Path $tmpdir $archive
    Invoke-WebRequest -Uri $url -OutFile $archivePath

    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Expand-Archive -Path $archivePath -DestinationPath $tmpdir -Force

    $binaryName = "$BinName.exe"
    Copy-Item -Force (Join-Path $tmpdir $binaryName) (Join-Path $InstallDir $binaryName)

    Write-Host ""
    Write-Host "Installed $binaryName $Version to $(Join-Path $InstallDir $binaryName)"
    if (-not (($env:PATH -split ';') -contains $InstallDir)) {
        Write-Host "Note: $InstallDir is not currently on PATH."
        Write-Host "Add it to your user PATH if needed."
    }
}
finally {
    if (Test-Path $tmpdir) {
        Remove-Item -Recurse -Force $tmpdir
    }
}
