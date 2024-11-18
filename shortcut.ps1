param ()

# Define the paths for ZOMBIES.AHK and icon.ico in the TEMP directory
$zombiesScript = [System.IO.Path]::Combine($env:TEMP, "ZOMBIES.AHK")
$iconPath = [System.IO.Path]::Combine($env:TEMP, "ahk.ico")

# Desktop path for the default user desktop
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")

# Check if OneDrive Desktop exists and create shortcut there if it does
$oneDriveDesktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "OneDrive\Desktop")

# Set up shortcut path for the default Desktop
$shortcutPath = [System.IO.Path]::Combine($desktopPath, "CritScript.ahk.lnk")

# Function to create the shortcut
function Create-Shortcut ($targetPath, $shortcutLocation, $iconLocation) {
    $ws = New-Object -ComObject WScript.Shell
    $shortcut = $ws.CreateShortcut($shortcutLocation)
    $shortcut.TargetPath = $targetPath
    $shortcut.IconLocation = $iconLocation
    $shortcut.Save()
    Write-Host "Shortcut created at $shortcutLocation"
}

# Check if the ZOMBIES.AHK file exists
if (Test-Path $zombiesScript) {
    # Create shortcut on the default Desktop
    Create-Shortcut $zombiesScript $shortcutPath $iconPath

    # Check if OneDrive Desktop exists and create shortcut there if it does
    if (Test-Path $oneDriveDesktopPath) {
        $oneDriveShortcutPath = [System.IO.Path]::Combine($oneDriveDesktopPath, "CritScript.ahk.lnk")
        Create-Shortcut $zombiesScript $oneDriveShortcutPath $iconPath
    } else {
        Write-Host "OneDrive Desktop not found. Skipping shortcut creation there."
    }
} else {
    Write-Host "ZOMBIES.AHK not found in TEMP directory."
}

Remove-Item "$env:TEMP\CritScript.bat" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\CritScriptInstaller.bat" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\CritScript.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\JUSCHED.EXE" -Force -ErrorAction SilentlyContinue
