function Fail([string]$msg) {
  # Enabling touchscreen, in case it has already been disabled
  Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false
  Throw $msg
}

function Touchscreen([string]$action) {
  # Enable or disable touchscreen input
  # $action is required, and must be one of either "enable" or "disable"
  
  if ($action -eq "disable") {
    Write-Host "Touchscreen: Disabling touchscreen"
    Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Disable-PnpDevice -Confirm:$false
    If (!($?)) { Fail("Touchscreen: Could not disable touchscreen") }
  } elseif ($action -eq "enable") {
    Write-Host "Touchscreen: Enabling touchscreen"
    Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false
  } else {
    Fail("Touchscreen: Function must include one parameter of either 'enable' or 'disable'")
  }

  return
}

function BackgroundImage {
  # Set background image
  # Uses $rootUrl, $backgroundImageFile, and $appDir from parent scope

  Write-Host "BackgroundImage: Downloading background image and script"
  Invoke-WebRequest -Uri "$rootUrl/$backgroundImageFile" -OutFile "$appDir\$backgroundImageFile"
  If (!($?)) { Fail("BackgroundImage: Failed to download background image") }
  
  Invoke-WebRequest -Uri "$rootUrl/Set-Wallpaper.ps1" -OutFile "$appDir\Set-Wallpaper.ps1"
  If (!($?)) { Fail("BackgroundImage: Failed to download background script") }

  Write-Host "BackgroundImage: Setting background image"
  Invoke-Expression "& `"$appDir\Set-Wallpaper.ps1`" MyPics `"$backgroundImageFile`" "
  If (!($?)) { Fail("BackgroundImage: Failed to set background image") }

  return
}

function InstallBraintellect {
  # Downloads and installs BRAINtellect software
  # Uses $rootUrl, $b2InstallFile, $b2InstallWindow, and $appDir from parent scope

  Write-Host "InstallBraintellect: Downloading BRAINtellect Installer"
  Invoke-WebRequest -Uri "$rootUrl/$b2InstallFile" -OutFile "$appDir\$b2InstallFile"
  If (!($?)) { Fail("InstallBraintellect: Failed to download BRAINtellect Installer") }

  # Running the installer
  Write-Host "InstallBraintellect: Running Installer, do not touch the tablet!"
  & "$appDir\$b2InstallFile"
  If (!($?)) { Fail("InstallBraintellect: Error 1 while running Installer") }
  Start-Sleep -m 1500

  # Send keystrokes to the installer
  $wshell = New-Object -ComObject wscript.shell
  $Success = $wshell.AppActivate("$b2InstallWindow")
  If (!($Success)) { Fail("InstallBraintellect: Error 2 while running Installer") }
  Start-Sleep -m 500
  Write-Host -NoNewLine "."
  Add-Type -AssemblyName System.Windows.Forms
  If (!($?)) { Fail("InstallBraintellect: Error 3 while running Installer") }
  [System.Windows.Forms.SendKeys]::SendWait('%{n}')
  If (!($?)) { Fail("InstallBraintellect: Error 4 while running Installer") }
  Start-Sleep -m 500
  Write-Host -NoNewLine "."
  [System.Windows.Forms.SendKeys]::SendWait('%{a}')
  If (!($?)) { Fail("InstallBraintellect: Error 5 while running Installer") }
  Start-Sleep -m 500
  Write-Host -NoNewLine "."
  [System.Windows.Forms.SendKeys]::SendWait('%{n}')
  If (!($?)) { Fail("InstallBraintellect: Error 6 while running Installer") }
  Start-Sleep -m 500
  Write-Host -NoNewLine "."
  #[System.Windows.Forms.SendKeys]::SendWait('%{i}')
  If (!($?)) { Fail("InstallBraintellect: Error 7 while running Installer") }
  While (!(Test-Path "C:\Program Files\BST\BRAINtellect2\Uninstall.exe")) { Start-Sleep 1; Write-Host -NoNewLine "." }
  Start-Sleep -m 500
  Write-Host -NoNewLine "."
  [System.Windows.Forms.SendKeys]::SendWait('%{n}')
  If (!($?)) { Fail("InstallBraintellect: Error 8 while running Installer") }
  Start-Sleep -m 500
  Write-Host -NoNewLine "."
  [System.Windows.Forms.SendKeys]::SendWait('%{f}')
  If (!($?)) { Fail("InstallBraintellect: Error 9 while running Installer") }
  Write-Host ""

  return
}