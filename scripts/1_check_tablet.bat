@echo off
cd /d "%~dp0"
set LOG=%~dp0log_1_check.txt
echo ==== %date% %time% ==== > "%LOG%"
platform-tools\adb.exe kill-server >> "%LOG%" 2>&1
platform-tools\adb.exe start-server >> "%LOG%" 2>&1
echo --- devices --- >> "%LOG%"
platform-tools\adb.exe devices -l >> "%LOG%" 2>&1
echo --- if unauthorized: accept the prompt on the tablet, then run this again --- 
for %%P in (ro.product.model ro.product.device ro.serialno ro.vendor.display.paneltype ro.build.display.id ro.build.version.release ro.boot.flash.locked ro.boot.verifiedbootstate ro.oem_unlock_supported sys.oem_unlock_allowed ro.boot.slot_suffix ro.config.lgsi.region ro.product.locale) do (
  echo %%P= >> "%LOG%"
  platform-tools\adb.exe shell getprop %%P >> "%LOG%" 2>&1
)
echo --- storage --- >> "%LOG%"
platform-tools\adb.exe shell df -h /data /sdcard >> "%LOG%" 2>&1
platform-tools\adb.exe shell dumpsys battery >> "%LOG%" 2>&1
echo DONE >> "%LOG%"
type "%LOG%"
timeout /t 8
