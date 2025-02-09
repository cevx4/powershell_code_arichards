$importSupportVarsFile = Join-Path -Path $PSScriptRoot -ChildPath "support_vars.ps1"
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

function printShortcutsInfoToScreen2 {
    printShortcutsToScreen
    exit
}

function c {
    Write-Host "Function C is running..."
    # Add your code for function C here
}

function d {
    Write-Host "Function D is running..."
    # Add your code for function D here
}

function e {
    Write-Host "Function E is running..."
    # Add your code for function E here
}

# Function to display the menu
function Show-Menu {
    Clear-Host
    Write-Host "Select an option from the menu:`n"
    Write-Host "1. Run function a"
    Write-Host "2. Print shortcuts"
    Write-Host "3. Run function c"
    Write-Host "4. Run function d"
    Write-Host "5. Run function e"
    Write-Host "q. Quit`n"
}

# Main loop to handle user input
while ($true) {
    
    # executes the script in the current session
    #. $importSupportVarsFile
    . $importSupportFunctionsFile
    
    # runs menu
    Show-Menu

    # unrestrict access for current user
    setCurrentUserUnrestrictAccess

    # prompts user to make a choice
    $choice = Read-Host "Enter your choice (1-5 or 'q' to quit)"

    switch ($choice) {
        '1' { 
                a  
            }
        '2' { 
                printShortcutsInfoToScreen2 
            }
        '3' { c }
        '4' { d }
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
