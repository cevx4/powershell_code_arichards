$importSupportVarsFile = Join-Path -Path $PSScriptRoot -ChildPath "support_vars.ps1"

function getAllShortcuts {
    
    # executes the script in the current session
    . $importSupportVarsFile


    # Define the starting directory (you can modify this as needed)
    $startPath = $workingEnvPathInfo.currentDrive + $workingEnvPathInfo.currentDir

    # Get all shortcuts (.lnk files) recursively
    $shortcuts = Get-ChildItem -Path $startPath -Filter "*.lnk" -Recurse -ErrorAction SilentlyContinue

    # Ensure we process valid shortcuts and retrieve their target paths
    $shortcutDetails = foreach ($shortcut in $shortcuts) {
        try {
            # Use Shell COM object to extract shortcut details
            $shell = New-Object -ComObject WScript.Shell
            $shortcutObject = $shell.CreateShortcut($shortcut.FullName)


            [PSCustomObject]@{
                Name       = $shortcut.Name
                FullPath   = $shortcut.FullName
                TargetPath = $shortcutObject.TargetPath            
            }


        } catch {
            Write-Warning "Failed to process: $($shortcut.FullName)"
        }
    }

    #$shortcutDetails | Format-Table -AutoSize
    #$shortcutDetails | Export-Csv -Path "G:\Shortcuts2.csv" -NoTypeInformation
    #exportAllShortcutsToCSVFile -shortcutsObject $shortcutDetails
    printShortcutsToScreen -shortcutsObject $shortcutDetails
}


function printShortcutsToScreen{
    
    param (
        [PSCustomObject]$InputObject
    )

    #Write-Host $InputObject.Name, 
    $InputObject | Format-Table -AutoSize

}

getAllShortcuts


