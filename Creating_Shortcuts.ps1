function Create-Shortcut {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ShortcutTargetPath,   # Full path to the shortcut file (e.g., C:\path\to\shortcut.lnk)

        [Parameter(Mandatory = $true)]
        [string]$ShortcutTargetSourceLocation,     # Full path to the target file or folder (e.g., C:\path\to\target.exe)

        [string]$DescriptionComments = "" # Optional description for the shortcut
        #[string]$WorkingDirectory = "" # Optional working directory
        #[string]$IconLocation = "" # Optional path to the icon file (e.g., C:\path\to\icon.ico)
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


Create-Shortcut `
    -ShortcutTargetPath "G:\mrcevallosgdrive\Monique4.lnk" `
    -ShortcutTargetSourceLocation "C:\Users\MCXIV\Pictures" `
    -DescriptionComments "Launch MyApp"
    
    
    
    #-WorkingDirectory "G:\" 
    
    
    
    #-IconLocation "C:\Program Files\MyApp\MyApp.ico"