@echo off
setlocal enabledelayedexpansion
rem ZUXOS Lite 1.5.10.184 (Android 16 CN) for Lenovo Legion Y700 Gen3 TB321FU - fastboot installer
rem WIPES THE TABLET. Bootloader must be unlocked. Tablet in fastboot mode, USB connected.
cd /d "%~dp0"
set FB=%~dp0platform-tools\fastboot.exe
set I=%~dp0images
set LOG=%~dp0log_flash_zuxos.txt
echo ==== %date% %time% ==== > "%LOG%"
"%FB%" getvar product 2>&1 | findstr /c:"kirby" >nul || ( echo ABORT: not a TB321FU in fastboot >> "%LOG%" & goto end )
"%FB%" getvar unlocked 2>&1 | findstr /c:"unlocked: yes" >nul || ( echo ABORT: bootloader locked >> "%LOG%" & goto end )
echo --- set slot a --- >> "%LOG%"
"%FB%" --set-active=a >> "%LOG%" 2>&1
echo --- firmware + boot images, both slots --- >> "%LOG%"
for %%P in (xbl xbl_config xbl_ramdump abl aop aop_config tz hyp devcfg keymaster qupfw uefi uefisecapp shrm cpucp cpucp_dtb imagefv featenabler multiimgoem multiimgqti pvmfw qweslicstore bluetooth dsp modem dtbo boot vendor_boot recovery vbmeta vbmeta_system) do (
  "%FB%" flash %%P_a "%I%\%%P.img" >> "%LOG%" 2>&1 || "%FB%" flash %%P "%I%\%%P.img" >> "%LOG%" 2>&1 || echo FAIL %%P >> "%LOG%"
  "%FB%" flash %%P_b "%I%\%%P.img" >> "%LOG%" 2>&1
)
echo --- init_boot with Magisk root --- >> "%LOG%"
"%FB%" flash init_boot_a "%~dp0init_boot_magisk.img" >> "%LOG%" 2>&1 || echo FAIL init_boot >> "%LOG%"
"%FB%" flash init_boot_b "%~dp0init_boot_magisk.img" >> "%LOG%" 2>&1
echo --- recreate dynamic partition table --- >> "%LOG%"
"%FB%" wipe-super "%~dp0super_empty.img" >> "%LOG%" 2>&1 || echo FAIL wipe-super >> "%LOG%"
echo --- reboot to fastbootd --- >> "%LOG%"
"%FB%" reboot fastboot >> "%LOG%" 2>&1
timeout /t 40 /nobreak >nul
"%FB%" getvar is-userspace >> "%LOG%" 2>&1
for %%P in (system system_ext product vendor odm vendor_dlkm system_dlkm) do (
  "%FB%" flash %%P "%I%\%%P.img" >> "%LOG%" 2>&1 || echo FAIL %%P >> "%LOG%"
)
echo --- wipe data --- >> "%LOG%"
"%FB%" -w >> "%LOG%" 2>&1
"%FB%" reboot >> "%LOG%" 2>&1
echo FLASH_DONE >> "%LOG%"
:end
echo DONE >> "%LOG%"
