<#
PowerShell script to configure B-2 tablets
Created by Data Tech Cafe
#>

# Initialization
$rootUrl = "https://datatechcafe.com/download/dtccfg"
$appDir = "${Env:ProgramFiles}\dtccfg"
Invoke-WebRequest -Uri "$rootUrl/server.ps1" -OutFile "$appDir\server.ps1"

# Run server script
& "$appDir\server.ps1"