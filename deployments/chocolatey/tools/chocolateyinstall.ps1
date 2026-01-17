$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = "https://github.com/phamminhkhoa2k4/khoata-tool/releases/download/v1.0.0/ag-khoata-windows-amd64.exe"
# $checksum   = "REPLACE_WITH_SHA256_OF_WINDOWS_BINARY"

$packageArgs = @{
    packageName   = 'ag-khoata'
    fileType      = 'exe'
    url64         = $url
    # checksum64    = $checksum 
    # checksumType64= 'sha256'
    destination   = $toolsDir
    fileName      = 'ag-khoata.exe'
}

Install-ChocolateyZipPackage @packageArgs
