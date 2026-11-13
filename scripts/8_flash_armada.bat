@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
set FB=platform-tools\fastboot.exe
set LOG=%~dp0log_8_flash.txt
echo ==== %date% %time% ==== > "%LOG%"
rem --- if tablet is in Android/recovery, send it to bootloader ---
for /f %%S in ('platform-tools\adb.exe get-state 2^>nul') do set ADBST=%%S
if defined ADBST (
  echo adb state !ADBST!, rebooting to bootloader >> "%LOG%"
  platform-tools\adb.exe reboot bootloader >> "%LOG%" 2>&1
  timeout /t 25 /nobreak >nul
)
%FB% devices >> "%LOG%" 2>&1
set UNL=
for /f "tokens=2" %%U in ('%FB% getvar unlocked 2^>^&1 ^| findstr /b "unlocked:"') do set UNL=%%U
echo unlocked=!UNL! >> "%LOG%"
if /i not "!UNL!"=="yes" (
  echo ABORT: bootloader not unlocked, nothing flashed >> "%LOG%"
  echo DONE >> "%LOG%"
  exit /b 1
)
set SLOT=
for /f "tokens=2" %%U in ('%FB% getvar current-slot 2^>^&1 ^| findstr /b "current-slot:"') do set SLOT=%%U
if "!SLOT!"=="" set SLOT=a
echo slot=!SLOT! >> "%LOG%"
echo --- flash boot_!SLOT! --- >> "%LOG%"
%FB% flash boot_!SLOT! boot.img >> "%LOG%" 2>&1 || goto fail
echo --- flash super --- >> "%LOG%"
%FB% flash super super.img >> "%LOG%" 2>&1 || goto fail
echo --- flash userdata (several minutes) --- >> "%LOG%"
%FB% -S 700M flash userdata userdata.simg >> "%LOG%" 2>&1 || goto fail
echo --- reboot --- >> "%LOG%"
%FB% reboot >> "%LOG%" 2>&1
echo FLASH_OK >> "%LOG%"
echo DONE >> "%LOG%"
exit /b 0
:fail
echo FLASH_FAILED at %time% >> "%LOG%"
echo DONE >> "%LOG%"
exit /b 1
