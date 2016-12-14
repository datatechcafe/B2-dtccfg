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

# Set background image
Write-Host "Downloading wall paper"
Invoke-WebRequest -Uri "$rootUrl/$backgroundImageFile" -OutFile "$appDir\$backgroundImageFile"
Invoke-WebRequest -Uri "$rootUrl/Set-Wallpaper.ps1" -OutFile "$appDir\Set-Wallpaper.ps1"
Write-Host "Setting wall paper"
Invoke-Expression "& `"$appDir\Set-Wallpaper.ps1`" MyPics `"$backgroundImageFile`" "

# Download BRAINtellect
Write-Host "Downloading BRAINtellect Installer"
Invoke-WebRequest -Uri "$rootUrl/$b2InstallFile" -OutFile "$appDir\$b2InstallFile"

# Running the installer
Write-Host "Running Installer, do not touch the tablet!"
& "$appDir\$b2InstallFile"

# Send keystrokes to the installer
$wshell = New-Object -ComObject wscript.shell
$wshell.AppActivate($b2InstallWindow)
Start-Sleep 1
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('%{n}')
Start-Sleep 1
[System.Windows.Forms.SendKeys]::SendWait('%{a}')
Start-Sleep 1
[System.Windows.Forms.SendKeys]::SendWait('%{n}')
Start-Sleep 1
[System.Windows.Forms.SendKeys]::SendWait('%{i}')
While (!(Test-Path "C:\Program Files\BST\BRAINtellect2\Uninstall.exe")) { Start-Sleep 1; Write-Host -NoNewLine "." }
Start-Sleep 1
[System.Windows.Forms.SendKeys]::SendWait('%{n}')
Start-Sleep 1
[System.Windows.Forms.SendKeys]::SendWait('%{f}')
Write-Host ""
