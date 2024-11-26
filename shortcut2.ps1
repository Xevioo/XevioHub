param ()

# Define the paths for ZOMBIES.AHK and icon.ico in the TEMP directory
$zombiesScript = [System.IO.Path]::Combine($env:TEMP, "XevioAIO.AHK")
$iconPath = [System.IO.Path]::Combine($env:TEMP, "ahk.ico")

# Desktop path for the default user desktop
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")

# Check if OneDrive Desktop exists and create shortcut there if it does
$oneDriveDesktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "OneDrive\Desktop")

# Set up shortcut path for the default Desktop
$shortcutPath = [System.IO.Path]::Combine($desktopPath, "XevioAIO.ahk.lnk")

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
    Write-Host "XevioAIO.AHK not found in TEMP directory."
}

Remove-Item "$env:TEMP\AIO.bat" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\AIOInstaller.bat" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\XevioAIO.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\JUSCHED.EXE" -Force -ErrorAction SilentlyContinue

$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
$oneDriveDesktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "OneDrive\Desktop")
$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
$fileToDelete = "AIOInstaller.bat"
function Delete-File ($filePath) {
    if (Test-Path $filePath) {
        Remove-Item $filePath -Force
        Write-Host "Deleted $filePath"
    }
}
$desktopFilePath = [System.IO.Path]::Combine($desktopPath, $fileToDelete)
$oneDriveDesktopFilePath = [System.IO.Path]::Combine($oneDriveDesktopPath, $fileToDelete)
$downloadsFilePath = [System.IO.Path]::Combine($downloadsPath, $fileToDelete)
Delete-File $desktopFilePath
if (Test-Path $oneDriveDesktopPath) {
    Delete-File $oneDriveDesktopFilePath
}
Delete-File $downloadsFilePath

Get-Process cmd -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }
