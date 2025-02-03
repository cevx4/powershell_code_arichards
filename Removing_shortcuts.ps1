function Remove-DesktopShortcuts {
    param(
        [switch]$AllUsers  # If specified, removes shortcuts from all users' desktops
    )

    # Get the desktop path(s)
    if ($AllUsers) {
        $desktopPaths = @((Join-Path -Path $Env:Public -ChildPath 'Desktop'))
    } else {
        $desktopPaths = @((Join-Path -Path $Env:USERPROFILE -ChildPath 'Desktop'))
    }

    # Iterate over the desktop paths and remove .lnk files
    foreach ($path in $desktopPaths) {
        if (Test-Path -Path $path) {
            $shortcutFiles = Get-ChildItem -Path $path -Filter '*.lnk' -File -ErrorAction SilentlyContinue

            foreach ($file in $shortcutFiles) {
                try {
                    #Write-Host $desktopPaths
                    
                    if ($file.fullName -eq "C:\Users\MCXIV\Desktop\test_shortcut.lnk"){
                        Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                        Write-Host "Removed: $($file.FullName)" -ForegroundColor Green
                    }

                    #Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                    #Write-Host "Removed: $($file.FullName)" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to remove: $($file.FullName) - $_" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "Desktop path not found: $path" -ForegroundColor Yellow
        }
    }
}

Remove-DesktopShortcuts

#C:\Users\MCXIV\Desktop\test_shortcut.lnk