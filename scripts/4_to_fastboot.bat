@echo off
cd /d "%~dp0"
set LOG=%~dp0log_4_fastboot.txt
echo ==== %date% %time% ==== > "%LOG%"
echo bootload_sn= >> "%LOG%"
platform-tools\adb.exe shell getprop ro.boot.bootload_sn >> "%LOG%" 2>&1
platform-tools\adb.exe shell getprop ro.boot.serialno >> "%LOG%" 2>&1
echo --- rebooting to bootloader --- >> "%LOG%"
platform-tools\adb.exe reboot bootloader >> "%LOG%" 2>&1
timeout /t 20 /nobreak
platform-tools\fastboot.exe devices >> "%LOG%" 2>&1
platform-tools\fastboot.exe getvar Bootloader_SN_Part1 >> "%LOG%" 2>&1
platform-tools\fastboot.exe getvar Bootloader_SN_Part2 >> "%LOG%" 2>&1
platform-tools\fastboot.exe getvar unlocked >> "%LOG%" 2>&1
platform-tools\fastboot.exe getvar current-slot >> "%LOG%" 2>&1
platform-tools\fastboot.exe getvar all >> "%LOG%" 2>&1
echo DONE >> "%LOG%"
