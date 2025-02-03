function Read-CsvFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if (Test-Path $FilePath) {
        try {
            $csvData = Import-Csv -Path $FilePath
            Write-Host "CSV file successfully read." -ForegroundColor Green
            return $csvData
        } catch {
            Write-Error "An error occurred while reading the CSV file: $_"
        }
    } else {
        Write-Error "The file path '$FilePath' does not exist."
    }
}

# Example usage
$data = Read-CsvFile -FilePath "G:\Shortcuts.csv"
$data | Format-Table
