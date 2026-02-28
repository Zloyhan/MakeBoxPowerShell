function New-MkBoxFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("n", "Name")]
        [string[]]$FileName
    )

    begin {
        if ($null -eq (Ensure-MkBoxWorkspaceRoot)) {
            $skipMkBoxFile = $true
            return
        }

        $skipMkBoxFile = $false
        $currentDir = (Get-Location).Path
        $createdCount = 0
        $skippedCount = 0
    }

    process {
        if ($skipMkBoxFile) {
            return
        }

        foreach ($name in $FileName) {
            if ([string]::IsNullOrWhiteSpace($name)) {
                Write-MkBoxHost -m "Skipped empty file name." -t "wr"
                $skippedCount++
                continue
            }

            $targetPath = Join-Path -Path $currentDir -ChildPath $name

            if (Test-Path -Path $targetPath) {
                $existingItem = Get-Item -Path $targetPath -Force -ErrorAction SilentlyContinue
                if ($null -ne $existingItem -and $existingItem.PSIsContainer) {
                    Write-MkBoxHost -m "Cannot create file. Folder already exists with same name: $name" -t "wr"
                }
                else {
                    Write-MkBoxHost -m "File already exists, skipped: $name" -t "wr"
                }
                $skippedCount++
                continue
            }

            try {
                New-Item -Path $targetPath -ItemType File -Force -ErrorAction Stop | Out-Null
                Write-MkBoxHost -m "Created file: $name" -t "dn"
                $createdCount++
            }
            catch {
                Write-MkBoxHost -m "[MKBOX-ERR-NEWFILE-001] File create failed. Reason: '$name' could not be created. Fix: Check name validity, permissions, and path locks." -t "err"
                $skippedCount++
            }
        }
    }

    end {
        if ($skipMkBoxFile) {
            return
        }

        Write-Host ""
        Write-MkBoxHost -m "File summary: created=$createdCount skipped=$skippedCount" -t "i"
        return
    }
}
