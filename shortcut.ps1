param ()

# Define the paths for ZOMBIES.AHK and icon.ico in the TEMP directory
$zombiesScript = [System.IO.Path]::Combine($env:TEMP, "ZOMBIES.AHK")
$iconPath = [System.IO.Path]::Combine($env:TEMP, "ahk.ico")

# Determine the correct Desktop path
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
if (Test-Path "$env:USERPROFILE\OneDrive\Desktop") {
    $desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "OneDrive\Desktop")
}

# Set the path for the shortcut
$shortcutPath = [System.IO.Path]::Combine($desktopPath, "CritScript.ahk.lnk")

# Check if the ZOMBIES.AHK file exists
if (Test-Path $zombiesScript) {
    # Create the shortcut
    $ws = New-Object -ComObject WScript.Shell
    $shortcut = $ws.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $zombiesScript
    $shortcut.IconLocation = $iconPath
    $shortcut.Save()

    Write-Host "Shortcut created at $shortcutPath"
} else {
    Write-Host "ZOMBIES.AHK not found in TEMP directory."
}
