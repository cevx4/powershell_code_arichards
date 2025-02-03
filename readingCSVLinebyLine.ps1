function Read-CsvLineByLine {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if (Test-Path $FilePath) {
        try {
            # Read the file content
            $lines = Get-Content -Path $FilePath

            # Split the first line into headers
            $headers = $lines[0] -split ','

            Write-Host "Headers:" -ForegroundColor Cyan
            $headers | ForEach-Object { Write-Host "  $_" }

            # Process each subsequent line
            for ($i = 1; $i -lt $lines.Length; $i++) {
                $line = $lines[$i] -split ','
                $record = @{}

                # Map values to headers
                for ($j = 0; $j -lt $headers.Length; $j++) {
                    $record[$headers[$j]] = $line[$j]
                }

                Write-Host "Record $($i):" -ForegroundColor Green
                $record.GetEnumerator() `
                                        | ForEach-Object { `
                                            Write-Host "  $($_.Key): $($_.Value)" 
                                          }
            }
        } catch {
            Write-Error "An error occurred while processing the file: $_"
        }
    } else {
        Write-Error "The file path '$FilePath' does not exist."
    }
}

# Example usage
Read-CsvLineByLine -FilePath "G:\Shortcuts.csv"
