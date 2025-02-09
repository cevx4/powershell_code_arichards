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
    return $shortcutDetails
}

function SelectTargetDirectory {
    Add-Type -AssemblyName System.Windows.Forms

    # Create a hidden form to ensure the dialog stays on top
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true

    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select a target directory"
    $folderBrowser.ShowNewFolderButton = $true

    # Show the dialog with the form as the owner to keep it on top
    if ($folderBrowser.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    } else {
        return $null
    }
}

function printShortcutsToScreen {
    $shortcutsToPrint = getAllShortcuts 
    $shortcutsToPrint | Format-Table -AutoSize
}

function setCurrentUserUnrestrictAccess{
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
}

function exportShortcutsToCSVfile {
    $shortcutsToExport = getAllShortcuts
    $targetDir = SelectTargetDirectory 

    if($targetDir -eq $null){
        Write-Host "You did not select a target directory"
    }
    else {
        $shortcutsToExport | Export-Csv -Path ($targetDir + "\exprt.csv") -NoTypeInformation
        write-host "shortcuts have now been exported to: " + $targetDir
    }
    #$shortcutDetails | Export-Csv -Path "G:\Shortcuts2.csv" -NoTypeInformation
}


exportShortcutsToCSVfile

