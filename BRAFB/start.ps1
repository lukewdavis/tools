# Relaunch as admin if needed
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Start-Process PowerShell.exe `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs
    exit
}

$Url = "https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/releases/download/3.8.4/PSAppDeployToolkit_v3.8.4.zip"
$shctURL = "https://tools.thelukedavis.com/BRAFB/Remote%Work%20VPN.lnk"
$deployURL = "https://tools.thelukedavis.com/BRAFB/Deploy-SonicWallGVC.ps1"
$installerURL = "https://tools.thelukedavis.com/BRAFB/GVCInstall64.msi"
$configURL = "https://tools.thelukedavis.com/BRAFB/default.rcf"
$startURL = "https://tools.thelukedavis.com/BRAFB/start.ps1"

$Dest = "C:\temp\SonicWallGVC\PSAppDeployToolkit_v3.8.4.zip"
$shctDest = "C:\temp\SonicWallGVC\Remote Work VPN.lnk"
$installerDest = "C:\temp\SonicWallGVC\GVCInstall64.msi"
$deployDest = "C:\temp\SonicWallGVC\Deploy-SonicWallGVC.ps1"
$configDest = "C:\temp\SonicWallGVC\default.rcf"
$startDest = "C:\temp\SonicWallGVC\start.ps1"

New-Item -ItemType Directory -Path C:\temp\SonicWallGVC -Force | Out-Null
Invoke-WebRequest -Uri $Url -OutFile $Dest

Invoke-WebRequest -Uri $shctURL -OutFile $shctDest

Invoke-WebRequest -Uri $deployURL -OutFile $deployDest

Invoke-WebRequest -Uri $installerURL -OutFile $installerDest

Invoke-WebRequest -Uri $configURL -OutFile $configDest

Invoke-WebRequest -Uri $startURL -OutFile $startDest

Unblock-File -Path C:\temp\SonicWallGVC\PSAppDeployToolkit_v3.8.4.zip

Expand-Archive -Path C:\temp\SonicWallGVC\PSAppDeployToolkit_v3.8.4.zip -DestinationPath C:\temp\PADT -Force

Copy-Item -Path "C:\temp\PADT\Toolkit\AppDeployToolkit" -Destination "C:\temp\SonicWallGVC\AppDeployToolkit" -Recurse

Copy-Item -Path "C:\temp\PADT\Toolkit\Files" -Destination "C:\temp\SonicWallGVC\Files" -Recurse -Force

Copy-Item -Path "C:\temp\SonicWallGVC\GVCInstall64.msi" -Destination "C:\temp\SonicWallGVC\Files"

& "C:\temp\SonicWallGVC\Deploy-SonicWallGVC.ps1" `
    -DeploymentType Install `
    -DeployMode NonInteractive

Copy-Item -Path "C:\temp\SonicWallGVC\default.rcf" -Destination "C:\Program Files\SonicWall\Global VPN Client"

Copy-Item -Path "C:\temp\SonicWallGVC\Remote Work VPN.lnk" -Destination "C:\Users\Public\Desktop"

# Cleanup temporary folders
if (Test-Path "C:\temp\SonicWallGVC") { Remove-Item -Path "C:\temp\SonicWallGVC" -Recurse -Force -ErrorAction SilentlyContinue }
if (Test-Path "C:\temp\PADT") { Remove-Item -Path "C:\temp\PADT" -Recurse -Force -ErrorAction SilentlyContinue }

