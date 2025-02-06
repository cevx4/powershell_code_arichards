# This is going to be the controller of all the other processes

# 1. Select menu 

# Define the functions for each menu option
function a {
    Write-Host "Function A is running..."
    # Add your code for function A here
}

function b {
    Write-Host "Function B is running..."
    # Add your code for function B here
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
    Write-Host "2. Run function b"
    Write-Host "3. Run function c"
    Write-Host "4. Run function d"
    Write-Host "5. Run function e"
    Write-Host "q. Quit`n"
}

# Main loop to handle user input
while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-5 or 'q' to quit)"

    switch ($choice) {
        '1' { a }
        '2' { b }
        '3' { c }
        '4' { d }
        '5' { e }
        'q' { exit }
        default { Write-Host "Invalid selection, please try again." }
    }
    
    # Pause so the user can see the output before clearing the screen
    Write-Host "`nPress Enter to continue..."
    [void][System.Console]::ReadKey($true)
}
