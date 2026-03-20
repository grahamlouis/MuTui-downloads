# MuTui Downloads

This repository hosts install scripts and release binaries for MuTui.

## Install

### macOS / Linux

```sh
curl -fsSL https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.sh | sh
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.ps1 | iex
```

## Useful Options

### Install a specific release

macOS / Linux:

```sh
VERSION=v0.1.0 curl -fsSL https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.sh | sh
```

Windows PowerShell:

```powershell
$env:VERSION="v0.1.0"
irm https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.ps1 | iex
```

### Install to a custom location

macOS / Linux:

```sh
INSTALL_DIR="$HOME/bin" curl -fsSL https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.sh | sh
```

Windows PowerShell:

```powershell
$env:INSTALL_DIR="$HOME\\bin"
irm https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.ps1 | iex
```

Release assets are published automatically from the private source repository.
