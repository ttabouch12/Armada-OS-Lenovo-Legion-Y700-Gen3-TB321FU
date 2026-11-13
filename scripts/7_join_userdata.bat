@echo off
cd /d "%~dp0"
set LOG=%~dp0log_7_join.txt
echo ==== %date% %time% start ==== > "%LOG%"
copy /b userdata.simg.part1+userdata.simg.part2+userdata.simg.part3+userdata.simg.part4+userdata.simg.part5+userdata.simg.part6+userdata.simg.part7 userdata.simg >> "%LOG%" 2>&1
echo ==== %date% %time% end ==== >> "%LOG%"
for %%A in (userdata.simg) do echo size=%%~zA >> "%LOG%"
echo DONE >> "%LOG%"
