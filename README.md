# MuTui Downloads

This repository hosts install scripts and release binaries for MuTui.

## Install

### macOS / Linux

```sh
curl -fsSL https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.sh | sh
```

On macOS, the install also provides a `mutui-setup` helper for loopback-audio setup.

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.ps1 | iex
```

## Useful Options

When `VERSION` is not set, the installers resolve the latest compatible public release for your platform.

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

### Override the runtime data root

macOS / Linux:

```sh
APP_ROOT="$HOME/custom-mutui-data" curl -fsSL https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.sh | sh
```

Windows PowerShell:

```powershell
$env:APP_ROOT="$HOME\\custom-mutui-data"
irm https://raw.githubusercontent.com/grahamlouis/MuTui-downloads/main/install.ps1 | iex
```

## Runtime Data Root

MuTui stores project state and bundled sample assets in a per-user runtime root instead of the current working directory:

- Windows: `%LOCALAPPDATA%\\MuTui`
- macOS: `~/Library/Application Support/MuTui`
- Linux: `${XDG_DATA_HOME:-~/.local/share}/mutui`

Release assets are published automatically from the private source repository.
