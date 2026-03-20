param(
    [string]$Repo = $(if ($env:REPO) { $env:REPO } else { "grahamlouis/MuTui-downloads" }),
    [string]$BinName = $(if ($env:BIN_NAME) { $env:BIN_NAME } else { "terminal-daw" }),
    [string]$InstallDir = $(if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA "MuTui\bin" }),
    [string]$AppRoot = $(if ($env:APP_ROOT) { $env:APP_ROOT } else { Join-Path $env:LOCALAPPDATA "MuTui" }),
    [string]$Version = $(if ($env:VERSION) { $env:VERSION } else { "latest" })
)

$ErrorActionPreference = "Stop"

function Get-LatestVersion {
    param(
        [string]$Repo,
        [string]$BinName,
        [string]$Target
    )

    $archiveSuffix = if ($Target -like "*windows*") { ".zip" } else { ".tar.gz" }
    $releases = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases?per_page=20"
    foreach ($release in $releases) {
        if ($release.draft) {
            continue
        }
        $expected = "$BinName-$($release.tag_name)-$Target$archiveSuffix"
        if ($release.assets | Where-Object { $_.name -eq $expected }) {
            return $release.tag_name
        }
    }

    throw "Failed to determine latest compatible release for $Repo"
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

function Normalize-PathEntry {
    param([string]$PathEntry)
    if (-not $PathEntry) {
        return ""
    }
    return $PathEntry.Trim().TrimEnd('\').ToUpperInvariant()
}

function Ensure-PathContains {
    param([string]$PathValue, [string]$Entry)
    $normalizedEntry = Normalize-PathEntry $Entry
    return (($PathValue -split ';') | ForEach-Object { Normalize-PathEntry $_ }) -contains $normalizedEntry
}

function Add-InstallDirToPath {
    param([string]$Entry)

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not (Ensure-PathContains -PathValue $userPath -Entry $Entry)) {
        $newUserPath = if ([string]::IsNullOrWhiteSpace($userPath)) {
            $Entry
        } else {
            "$userPath;$Entry"
        }
        [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
        Write-Host "Added $Entry to your user PATH."
    }

    if (-not (Ensure-PathContains -PathValue $env:PATH -Entry $Entry)) {
        $env:PATH = if ([string]::IsNullOrWhiteSpace($env:PATH)) {
            $Entry
        } else {
            "$env:PATH;$Entry"
        }
    }
}

function Copy-MissingAssets {
    param([string]$SourceDir, [string]$DestDir)

    if (-not (Test-Path $SourceDir)) {
        return
    }

    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    Get-ChildItem -Path $SourceDir -Filter *.aif | ForEach-Object {
        $dest = Join-Path $DestDir $_.Name
        if (-not (Test-Path $dest)) {
            Copy-Item $_.FullName $dest
        }
    }
}

if ($Version -eq "latest") {
    $Version = Get-LatestVersion -Repo $Repo -BinName $BinName -Target $target
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
    Copy-MissingAssets -SourceDir (Join-Path $tmpdir "assets\drum\user") -DestDir (Join-Path $AppRoot "drum\user")
    Copy-MissingAssets -SourceDir (Join-Path $tmpdir "assets\synth\user") -DestDir (Join-Path $AppRoot "synth\user")
    Add-InstallDirToPath -Entry $InstallDir

    Write-Host ""
    Write-Host "Installed $binaryName $Version to $(Join-Path $InstallDir $binaryName)"
    Write-Host "Runtime data root: $AppRoot"
    Write-Host "You can now run $BinName in this PowerShell session."
}
finally {
    if (Test-Path $tmpdir) {
        Remove-Item -Recurse -Force $tmpdir
    }
}
