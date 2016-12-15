<#
PowerShell script to configure B-2 tablets
Created by Data Tech Cafe
#>

Write-Host "DTC Config B-2 Tablet Setup v1.0.0"

# Initialization
$rootUrl = "https://datatechcafe.com/download/dtccfg"
$appDir = "${Env:ProgramFiles}\dtccfg"
$backgroundImageFile = "BRAINtellect-2-background-logo-1280x1280.png"
$b2InstallFile = "setup_BRAINtellect2_v5.1.36.exe"
$b2InstallWindow = "BST BRAINtellect2 v5.1.36 Setup"

# Main
. ./functions.ps1
BackgroundImage
Touchscreen("disable")
InstallBraintellect
Touchscreen("enable")
RemoveDesktopIcons

Write-Host "DTC Config: Configuration successful!"