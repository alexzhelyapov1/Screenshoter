#Requires -RunAsAdministrator

<#
.SYNOPSIS
Script to uninstall UpdateServiceScreen components.

.DESCRIPTION
1. Checks if the script is run as administrator.
2. Deletes the folder %APPDATA%\UpdateServiceScreen.
3. Removes the network share for C:\SS.
4. Deletes the folder C:\SS.
5. Deletes steam.lnk from the current user's Desktop.

.NOTES
Requires administrator privileges.
The steam.lnk will be deleted from the Desktop of the user running the script (the Administrator).
#>

Set-StrictMode -Version Latest

# 1. Check for Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as administrator."
    Start-Sleep -Seconds 5 # Give the user time to read
    Exit 1 # Exit with an error code
}
Write-Host "Administrator privileges confirmed." -ForegroundColor Green

# 2. Delete the %APPDATA%\UpdateServiceScreen folder
$appDataPath = Join-Path -Path $env:APPDATA -ChildPath "UpdateServiceScreen"
Write-Host "Deleting folder: $appDataPath"
if (Test-Path $appDataPath) {
    try {
        Remove-Item -Path $appDataPath -Recurse -Force -ErrorAction Stop
        Write-Host "Folder '$appDataPath' deleted successfully." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to delete folder '$appDataPath'. Error: $($_.Exception.Message)"
    }
} else {
    Write-Host "Folder '$appDataPath' not found. Skipping deletion." -ForegroundColor Yellow
}

# 3. Remove the network share for C:\SS
$shareName = "SS" # Must match the name used in install.ps1
Write-Host "Removing network share: $shareName"
try {
    if (Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue) {
        Remove-SmbShare -Name $shareName -Force -ErrorAction Stop
        Write-Host "Network share '$shareName' removed successfully." -ForegroundColor Green
    } else {
        Write-Host "Network share '$shareName' not found. Skipping removal." -ForegroundColor Yellow
    }
} catch {
    Write-Warning "Failed to remove network share '$shareName'. Error: $($_.Exception.Message)"
}

# 4. Delete the C:\SS folder
$ssFolderPath = "C:\SS"
Write-Host "Deleting folder: $ssFolderPath"
if (Test-Path $ssFolderPath) {
    try {
        # Try to remove the hidden attribute before deleting (might help)
        try {
            $item = Get-Item $ssFolderPath -ErrorAction Stop
            if ($item.Attributes -band [System.IO.FileAttributes]::Hidden) {
                $item.Attributes -= [System.IO.FileAttributes]::Hidden
            }
        } catch {
            Write-Warning "Failed to remove 'Hidden' attribute for folder '$ssFolderPath'."
        }
        Remove-Item -Path $ssFolderPath -Recurse -Force -ErrorAction Stop
        Write-Host "Folder '$ssFolderPath' deleted successfully." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to delete folder '$ssFolderPath'. Error: $($_.Exception.Message)"
    }
} else {
    Write-Host "Folder '$ssFolderPath' not found. Skipping deletion." -ForegroundColor Yellow
}

# 5. Delete steam.lnk from the Desktop
try {
    $desktopPath = [Environment]::GetFolderPath('Desktop')
    $targetLnk = Join-Path -Path $desktopPath -ChildPath "steam.lnk"

    Write-Host "Deleting shortcut from Desktop: $targetLnk"
    if (Test-Path $targetLnk) {
        Remove-Item -Path $targetLnk -Force -ErrorAction Stop
        Write-Host "Shortcut 'steam.lnk' deleted successfully from Desktop." -ForegroundColor Green
    } else {
        Write-Host "Shortcut '$targetLnk' not found on Desktop. Skipping deletion." -ForegroundColor Yellow
    }
} catch {
    Write-Warning "Failed to delete shortcut 'steam.lnk' from Desktop. Error: $($_.Exception.Message)"
}

Write-Host "Uninstallation complete." -ForegroundColor Green