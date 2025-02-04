function OptionA {
    Write-Host "You selected Option A"
}

function OptionB {
    Write-Host "You selected Option B"
}

function OptionC {
    Write-Host "You selected Option C"
}

function OptionD {
    Write-Host "You selected Option D"
}

function OptionE {
    Write-Host "You selected Option E"
}

while ($true) {
    Clear-Host
    Write-Host "User Menu"
    Write-Host "A) Option A"
    Write-Host "B) Option B"
    Write-Host "C) Option C"
    Write-Host "D) Option D"
    Write-Host "E) Option E"
    Write-Host "Q) Quit"

    $choice = Read-Host "Please select an option"

    switch ($choice.ToUpper()) {
        "A" { OptionA }
        "B" { OptionB }
        "C" { OptionC }
        "D" { OptionD }
        "E" { OptionE }
        "Q" { break }
        default { Write-Host "Invalid selection, please try again." }
    }
    
    Pause
}
