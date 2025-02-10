$importSupportVarsFile = Join-Path -Path $PSScriptRoot -ChildPath "support_vars.ps1"
$questionToBeAsked = ""

function getAllShortcuts {
    
    # executes the script in the current session
    . $importSupportVarsFile

    # Define the starting directory (you can modify this as needed)
    #$startPath = $workingEnvPathInfo.currentDrive + $workingEnvPathInfo.currentDir
    $startPath = SelectTargetDirectory
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

    $reminder = "You must remember to create shortcuts properly `n" +
                "For windows, right click on target DIR and select NEW > Shortcut `n"    

    if((promptUser -promptQuestion $reminder) -eq "Yes"){
        Write-Host "select directory that has shortcuts"
        $shortcutsToExport = getAllShortcuts
        Write-Host "select directory to export the csv file"
        $targetDir = SelectTargetDirectory 

        if($targetDir -eq $null){
        Write-Host "You did not select a target directory"
        }
        else {
        $shortcutsToExport | Export-Csv -Path ($targetDir + "\exprt7.csv") -NoTypeInformation
        write-host "Exported to: $($targetDir)"
        #$shortcutsToExport | Export-Csv -Path "G:\Shortcuts2.csv" -NoTypeInformation
        }
    }
    else{
        exit
    }


    
    
}

function promptUser {

    param (
        [Parameter(Mandatory = $true)]
        [string]$promptQuestion
    )

    $questionToBeAsked = $promptQuestion

    Add-Type -AssemblyName System.Windows.Forms

    $form = getFormObject
    $label = getLabelObject
    
    $buttonYes = getYesButtonObject
    $buttonNo = getNoButtonObject  

    $buttonYes.Add_Click(
        { 
            $global:userResponse = "Yes"
            $form.Close()
        }
      )          

    $buttonNo.Add_Click(
        { 
            $global:userResponse = "No"
            $form.Close()
        }
      )

    $form.Controls.Add($label)
    $form.Controls.Add($buttonYes)
    $form.Controls.Add($buttonNo)

    # Show the form
    $form.ShowDialog() | Out-Null

    # Output user response
    #Write-Output "User selected: $global:userResponse"
    return $global:userResponse
  
}

function getLabelObject {
    $newLabel = New-Object System.Windows.Forms.Label
    $newLabel.Text = $questionToBeAsked
    $newLabel.Size = New-Object System.Drawing.Size(280,40)
    $newLabel.Location = New-Object System.Drawing.Point(10,20)
    return $newLabel    
}

function getYesButtonObject {
    $yesButton = New-Object System.Windows.Forms.Button
    $yesButton.Text = "Yes"
    $yesButton.Size = New-Object System.Drawing.Size(80,30)
    $yesButton.Location = New-Object System.Drawing.Point(50,100)
    return $yesButton
}

function getNoButtonObject {
    $yesButton = New-Object System.Windows.Forms.Button
    $yesButton.Text = "No"
    $yesButton.Size = New-Object System.Drawing.Size(80,30)
    $yesButton.Location = New-Object System.Drawing.Point(150,100)
    return $yesButton
}

function getFormObject {
    $newForm = New-Object System.Windows.Forms.Form
    $newForm.Text = "Continue?"
    $newForm.Size = New-Object System.Drawing.Size(400,300)
    $newForm.StartPosition = "CenterScreen"
    return $newForm
}

function selectCSVFileFromComputer{
    # Open file explorer to select a CSV file
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
    $OpenFileDialog.Title = "Select a CSV File"
    $targetFile = ""

    if (-not ($OpenFileDialog.ShowDialog() -eq "OK")) {
        #
        Write-Output "No file selected."
        exit
    } 
    else {
        $targetFile = ($OpenFileDialog.FileName)
    }
    return $targetFile 
}

function createShortcutToTargetDir {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ShortcutTargetPath,   # Full path to the shortcut file (e.g., C:\path\to\shortcut.lnk)
        [Parameter(Mandatory = $true)]
        [string]$ShortcutTargetSourceLocation,     # Full path to the target file or folder (e.g., C:\path\to\target.exe)
        [string]$DescriptionComments = "" # Optional description for the shortcut

    )

    try {
        # Create a WScript.Shell COM object
        $Shell = New-Object -ComObject WScript.Shell

        # Create the shortcut
        $Shortcut = $Shell.CreateShortcut($ShortcutTargetPath)
        $Shortcut.TargetPath = $ShortcutTargetSourceLocation

        if ($DescriptionComments -ne $null) {
            $Shortcut.Description = $DescriptionComments
        }

        # Save the shortcut
        $Shortcut.Save()

        Write-Host "Shortcut created successfully at $ShortcutPath" -ForegroundColor Green
    } catch {
        Write-Host "Error creating shortcut: $_" -ForegroundColor Red
    }
}




function createShortcutsFromSelectedCSVFile {

    $csvFileToProcess = selectCSVFileFromComputer
    $targetDirectory = SelectTargetDirectory
    $lineCount = 1

    # Read the file line by line
    (Get-Content $csvFileToProcess) | ForEach-Object {
        $columns = $_ -split ","
        
        #Write-Output ("$($lineCount): $($targetDirectory)\$($columns[0])" + " " + $columns[1] + " " + $columns[2])
        Write-Output "looping through line: $($lineCount)"
        if($lineCount -eq 1){
        }
        else{
            createShortcutToTargetDir `
                -ShortcutTargetPath ("$($targetDirectory)\$($columns[0])").ToString() `
                -ShortcutTargetSourceLocation $columns[2] `
                -DescriptionComments "Launch MyApp"
        
        }
        $lineCount += 1
    }
}

# needs to be re-saved into a true csv file using notepadd++
#createShortcutsFromSelectedCSVFile




