#$importSupportVarsFile = Join-Path -Path $PSScriptRoot -ChildPath "support_vars.ps1"
$importSupportFunctionsFile = Join-Path -Path $PSScriptRoot -ChildPath "support_functions.ps1"



# This is going to be the controller of all the other processes

# 1. Select menu 

# Define the functions for each menu option
function a {
    Write-Host "Function A is running..."
    Write-Host $workingEnvPathInfo.currentDrive
    test1
    exit
    # Add your code for function A here
}

function printShortcutsInfoToScreen {
    printShortcutsToScreen
    exit
}

function exportShortCutsToCSV {
    #promptUser "Are you sure you want to export shortcuts?"
    exportShortcutsToCSVfile
    exit
}

function createShortcutsFromCSV {
   createShortcutsFromSelectedCSVFile
   exit
}

function getShortcutsFromADirectory {
    # Choose directory
}

# Function to display the menu
function Show-Menu {
    Clear-Host
    Write-Host "Select an option from the menu:`n"
    Write-Host "1. Print shortcuts from a directory - wrkn"
    Write-Host "2. Export shortcuts to a CSV file - not wrkn properly"
    Write-Host "3. Create shortcuts from a CSV file - not wrkn properly"
    Write-Host "4. Get shortcuts from a directory"
    Write-Host "5. Run function e"
    Write-Host "q. Quit`n"
}

# Main loop to handle user input
while ($true) {
    
    # executes the imported script in the current session
    . $importSupportFunctionsFile
    
    # runs menu
    Show-Menu

    # unrestrict access for current user
    setCurrentUserUnrestrictAccess

    # prompts user to make a choice
    $choice = Read-Host "Enter your choice (1-5 or 'q' to quit)"

    switch ($choice) {
        '1' { printShortcutsInfoToScreen }
        '2' { exportShortCutsToCSV }
        '3' { createShortcutsFromCSV }
        '4' { getShortcutsFromADirectory }
        '5' { e }
        'q' { 
            Write-Host "......`nYou are now exiting the program, please re-run again!"
            exit }
        default { Write-Host "Invalid selection, please try again." }
    }
    
    # Pause so the user can see the output before clearing the screen
    Write-Host "`nPress Enter to continue..."
    [void][System.Console]::ReadKey($true)
}
