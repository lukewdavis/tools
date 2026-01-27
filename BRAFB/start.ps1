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
$Dest = "C:\temp\SonicWallGVC\PSAppDeployToolkit_v3.8.4.zip"

New-Item -ItemType Directory -Path C:\temp\SonicWallGVC -Force | Out-Null
Invoke-WebRequest -Uri $Url -OutFile $Dest

Unblock-File -Path C:\temp\SonicWallGVC\PSAppDeployToolkit_v3.8.4.zip

Expand-Archive -Path C:\temp\SonicWallGVC\PSAppDeployToolkit_v3.8.4.zip -DestinationPath C:\temp\PADT -Force

Copy-Item -Path "C:\temp\PADT\Toolkit\AppDeployToolkit" -Destination "C:\temp\SonicWallGVC\AppDeployToolkit" -Recurse

Copy-Item -Path "C:\temp\PADT\Toolkit\Files" -Destination "C:\temp\SonicWallGVC\Files" -Recurse -Force

Copy-Item -Path "C:\temp\SonicWallGVC\GVCInstall64.msi" -Destination "C:\temp\SonicWallGVC\Files"

& "C:\temp\SonicWallGVC\Deploy-SonicWallGVC.ps1" `
    -DeploymentType Install `
    -DeployMode NonInteractive

Copy-Item -Path "C:\temp\SonicWallGVC\default.rcf" -Destination "C:\Program Files\SonicWall\Global VPN Client"

Copy-Item -Path "C:\temp\SonicWallGVC\BRAFB Verona VPN.lnk" -Destination "C:\Users\Public\Desktop"
