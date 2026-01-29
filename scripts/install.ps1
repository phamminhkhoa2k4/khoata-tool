# Ag-Khoata Installer Script for Windows
# Usage: iwr -useb https://raw.githubusercontent.com/phamminhkhoa2k4/khoata-tool/master/scripts/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Repo = "phamminhkhoa2k4/khoata-tool"
$BinaryName = "ag-khoata.exe"
$InstallDir = "$env:LOCALAPPDATA\ag-khoata"
$FileName = "ag-khoata-windows-amd64.exe"

# Create install directory
if (-not (Test-Path -Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

$Url = "https://github.com/$Repo/releases/latest/download/$FileName"
$OutputPath = Join-Path -Path $InstallDir -ChildPath $BinaryName

Write-Host "Downloading $BinaryName from $Url..."
Write-Host "Downloading $BinaryName from $Url..."
Invoke-WebRequest -Uri $Url -OutFile $OutputPath

# Create 'khoata' alias (copy of the exe)
$AliasPath = Join-Path -Path $InstallDir -ChildPath "khoata.exe"
Copy-Item -Path $OutputPath -Destination $AliasPath -Force
Write-Host "Created alias: khoata.exe"

# Add to PATH if not already present
$UserPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($UserPath -notlike "*$InstallDir*") {
    Write-Host "Adding $InstallDir to PATH..."
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", [EnvironmentVariableTarget]::User)
    $env:Path += ";$InstallDir"
    Write-Host "Path updated. You may need to restart your terminal."
}

Write-Host "Successfully installed $BinaryName!"
Write-Host "Run 'ag-khoata --help' to get started."
