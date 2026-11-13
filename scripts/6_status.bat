@echo off
cd /d "%~dp0"
set LOG=%~dp0log_6_status.txt
echo ==== %date% %time% ==== > "%LOG%"
echo --- fastboot --- >> "%LOG%"
platform-tools\fastboot.exe devices >> "%LOG%" 2>&1
echo --- adb --- >> "%LOG%"
platform-tools\adb.exe devices >> "%LOG%" 2>&1
platform-tools\fastboot.exe getvar unlocked >> "%LOG%" 2>&1
platform-tools\fastboot.exe getvar current-slot >> "%LOG%" 2>&1
echo DONE >> "%LOG%"
