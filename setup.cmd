@echo off

:Setup environment
md "%ProgramFiles%\dtccfg"
copy dtccfg.exe "%ProgramFiles%\dtccfg"
copy dtccfg.xml "%ProgramFiles%\dtccfg"
copy setup.ps1 "%ProgramFiles%\dtccfg"
copy service.ps1 "%ProgramFiles%\dtccfg"
copy functions.ps1 "%ProgramFiles%\dtccfg"

:Install service using winsw
:cd "%ProgramFiles%\dtccfg"
:dtccfg.exe install

:Set to triggered start
:sc triggerinfo dtccfg start/networkon
:sc triggerinfo dtccfg stop/networkoff

:Run setup.ps1
powershell.exe -ExecutionPolicy Bypass -File ./setup.ps1

:Start service and exit script
:dtccfg.exe start
