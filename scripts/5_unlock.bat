@echo off
cd /d "%~dp0"
set LOG=%~dp0log_5_unlock.txt
echo ==== %date% %time% ==== > "%LOG%"
platform-tools\fastboot.exe devices >> "%LOG%" 2>&1
platform-tools\fastboot.exe flash unlock sn.img >> "%LOG%" 2>&1
platform-tools\fastboot.exe oem unlock-go >> "%LOG%" 2>&1
echo --- after unlock-go --- >> "%LOG%"
echo DONE >> "%LOG%"
