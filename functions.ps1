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

  Return
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

  Return
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
  [System.Windows.Forms.SendKeys]::SendWait('%{i}')
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
  
  Write-Host "InstallBraintellect: Completed successfully"

  Return
}

function CopyImages {
  # Images provided by B-2 were copied to the server, and are pulled down to a
  # \Program Files\BST\Images directory, for use by other customizations of the tablet
  Write-Host "CopyImages: Copying custom BRAINtellect images"
  mkdir $b2Dir\Images
  Invoke-WebRequest -Uri "$rootUrl/Images/b-2.ico" -OutFile "$b2Dir\Images\b-2.ico"
  Invoke-WebRequest -Uri "$rootUrl/Images/B-2.png" -OutFile "$b2Dir\Images\B-2.png"
  Invoke-WebRequest -Uri "$rootUrl/Images/BRAINtellect.ico" -OutFile "$b2Dir\Images\BRAINtellect.ico"
  Invoke-WebRequest -Uri "$rootUrl/Images/BRAINtellect.png" -OutFile "$b2Dir\Images\BRAINtellect.png"
  Invoke-WebRequest -Uri "$rootUrl/Images/BRAINtellect-2-app-shortcut-icon-256x256.ico" -OutFile "$b2Dir\Images\BRAINtellect-2-app-shortcut-icon-256x256.ico"
  Invoke-WebRequest -Uri "$rootUrl/Images/BRAINtellect-2-background-logo-1280x1280.png" -OutFile "$b2Dir\Images\BRAINtellect-2-background-logo-1280x1280.png"
  Invoke-WebRequest -Uri "$rootUrl/Images/BRAINtellect-2-background-texture-1280x1280.png" -OutFile "$b2Dir\Images\BRAINtellect-2-background-texture-1280x1280.png"
  Invoke-WebRequest -Uri "$rootUrl/Images/BRAINtellect-2-lock-screen-1280x1280.png" -OutFile "$b2Dir\Images\BRAINtellect-2-lock-screen-1280x1280.png"
  Invoke-WebRequest -Uri "$rootUrl/Images/BRAINtellect-2-support-shortcut-icon-256x256.ico" -OutFile "$b2Dir\Images\BRAINtellect-2-support-shortcut-icon-256x256.ico"
  Invoke-WebRequest -Uri "$rootUrl/Images/bst-braintellect-2-user-account-square-2048sq.jpg" -OutFile "$b2Dir\Images\bst-braintellect-2-user-account-square-2048sq.jpg"
  Write-Host "CopyImages: Successfully copied images"
}

function RemoveDesktopIcons {
  Write-Host "RemoveDesktopIcons: Removing desktop icons"

  # Get rid of default shortcuts
  Remove-Item C:\Users\*\Desktop\*lnk -Force
  If (!($?)) { Fail("RemoveDesktopIcons: Problems deleting lnk files from Desktop") }

  # Hide Recycle Bin
  # Note, recycle bin will not disappear until the user logs out or computer restarts
  $policiesKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies"
  New-Item -Path $policiesKey -Name NonEnum
  New-ItemProperty -Path "$policiesKey\NonEnum" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 1 -PropertyType Dword
  # No error checking because we do not want to halt if it fails when reg keys or values already exist

  Write-Host "RemoveDesktopIcons: Desktop icons removed, Recycle Bin will disappear after the user logs out or the computer restarts"  

  Return
}

function AddDesktopIcons {
  Write-Host "AddDesktopIcons: Adding desktop icons"
  Invoke-WebRequest -Uri "$rootUrl/BRAINtellect 2.lnk" -OutFile "${Env:UserProfile}\Desktop\BRAINtellect 2.lnk"
  Invoke-WebRequest -Uri "$rootUrl/Support.url" -OutFile "${Env:UserProfile}\Desktop\Support.url"
  Write-Host "AddDesktopIcons: Successfully added desktop icons"
}

function ForceDesktopMode {
  Write-Host "ForceDesktopMode: Setting default UI to Desktop mode"
  $regImmersiveShell = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell"
  New-ItemProperty -Path $regImmersiveShell -Name "SignInMode" -Value 1 -PropertyType DWORD -Force
  If (!($?)) { Fail("ForceDesktopMode: Problems creating or updating SignInMode value") }
  New-ItemProperty -Path $regImmersiveShell -Name "TabletMode" -Value 0 -PropertyType DWORD -Force
  If (!($?)) { Fail("ForceDesktopMode: Problems creating or updating TabletMode value") }
  Write-Host "ForceDesktopMode: Successfully updated default UI to desktop mode, will take affect upon next tablet restart"
}