

function getAllShortcuts {

    

    # Define the starting directory (you can modify this as needed)
    $startPath = "G:\SampleDesktop" 

    # Get all shortcuts (.lnk files) recursively
    $shortcuts = Get-ChildItem -Path $startPath -Filter "*.lnk" -Recurse -ErrorAction SilentlyContinue

    # Ensure we process valid shortcuts and retrieve their target paths
    $shortcutDetails = foreach ($shortcut in $shortcuts) {
        try {
            # Use Shell COM object to extract shortcut details
            $shell = New-Object -ComObject WScript.Shell
            $shortcutObject = $shell.CreateShortcut($shortcut.FullName)
        
            #Write-Host $shortcut.Name, $shortcut.FullName, $shortcutObject.TargetPath

            #$shortcutName = ($shortcut.Name).split("-",3)[0]
            #Write-Host $shortcutName,$shortcutFullName



            [PSCustomObject]@{
                Name       = $shortcut.Name
                FullPath   = $shortcut.FullName
                TargetPath = $shortcutObject.TargetPath
            
            }
        } catch {
            Write-Warning "Failed to process: $($shortcut.FullName)"
        }
    }

    $shortcutDetails | Format-Table -AutoSize
    $shortcutDetails | Export-Csv -Path "G:\Shortcuts.csv" -NoTypeInformation

}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

getAllShortcuts

#Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser

# Display the results
#$shortcutDetails | Format-Table -AutoSize

#Write-Host $shortcutDetails


# Optionally, save the results to a CSV file
#$shortcutDetails | Export-Csv -Path "Shortcuts.csv" -NoTypeInformation
