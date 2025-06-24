# StealthScreenshot.ps1

# To run this script in the background, create a shortcut with this target:
#
# powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\path\to\StealthScreenshot.ps1" -TotalDuration 1800 -MinInterval 5 -MaxInterval 120  -SavePath "C:\Temp\MyScreenshots"

# powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\khkwa\repos\codes\PowerShell\StealthScreenshot_v2.ps1" -TotalDuration 300 -MinInterval 5 -MaxInterval 20  -SavePath "C:\Screenshots"

#
# Then double-click the shortcut.

param (
    [int]$TotalDuration = 12600,       # Default: 3.5 hours (in seconds)
    [int]$MinInterval = 10,          # Default: 10 seconds (minimum delay)
    [int]$MaxInterval = 60,         # Default: 5 minutes (maximum delay)
    [string]$SavePath = "$env:USERPROFILE\Documents\Screenshots"  # Default save folder
    # Set C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\khkwa\repos\codes\PowerShell\StealthScreenshot_v2.ps1" -TotalDuration 12600 -MinInterval 10 -MaxInterval 60  -SavePath "C:\Screenshots"
)

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create save directory if it doesn't exist
if (-not (Test-Path -Path $SavePath)) {
    New-Item -ItemType Directory -Path $SavePath -Force | Out-Null
}

# Log start time (optional)
"Script started at $(Get-Date) with Interval: $MinInterval-$MaxInterval seconds, Duration: $TotalDuration seconds" | 
    Out-File -FilePath "$SavePath\screenshot_log.txt" -Append

# Calculate end time
$endTime = (Get-Date).AddSeconds($TotalDuration)

# Main loop
while ((Get-Date) -lt $endTime) {
    # Generate random interval
    $interval = Get-Random -Minimum $MinInterval -Maximum $MaxInterval
    Start-Sleep -Seconds $interval
    
    try {
        # Capture screenshot
        $screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap = New-Object System.Drawing.Bitmap $screenBounds.Width, $screenBounds.Height
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($screenBounds.Location, [System.Drawing.Point]::Empty, $screenBounds.Size)
        
        # Save with timestamp
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $filename = Join-Path $SavePath "Screenshot_$timestamp.png"
        $bitmap.Save($filename, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Log (optional)
        "Screenshot saved: $filename at $(Get-Date)" | Out-File -FilePath "$SavePath\screenshot_log.txt" -Append
    }
    catch {
        "Error: $_ at $(Get-Date)" | Out-File -FilePath "$SavePath\screenshot_log.txt" -Append
    }
    finally {
        # Cleanup resources
        if ($graphics) { $graphics.Dispose() }
        if ($bitmap) { $bitmap.Dispose() }
    }
}

"Script ended at $(Get-Date)" | Out-File -FilePath "$SavePath\screenshot_log.txt" -Append