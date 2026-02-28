function New-MkBoxFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("n", "Name")]
        [string[]]$FolderName
    )

    begin {
        if ($null -eq (Ensure-MkBoxWorkspaceRoot)) {
            $skipMkBoxFolder = $true
            return
        }

        $skipMkBoxFolder = $false
        $currentDir = (Get-Location).Path
        $createdCount = 0
        $skippedCount = 0
    }

    process {
        if ($skipMkBoxFolder) {
            return
        }

        foreach ($name in $FolderName) {
            if ([string]::IsNullOrWhiteSpace($name)) {
                Write-MkBoxHost -m "Skipped empty folder name." -t "wr"
                $skippedCount++
                continue
            }

            $targetPath = Join-Path -Path $currentDir -ChildPath $name

            if (Test-Path -Path $targetPath) {
                $existingItem = Get-Item -Path $targetPath -Force -ErrorAction SilentlyContinue
                if ($null -ne $existingItem -and -not $existingItem.PSIsContainer) {
                    Write-MkBoxHost -m "Cannot create folder. File already exists with same name: $name" -t "wr"
                }
                else {
                    Write-MkBoxHost -m "Folder already exists, skipped: $name" -t "wr"
                }
                $skippedCount++
                continue
            }

            try {
                New-Item -Path $targetPath -ItemType Directory -ErrorAction Stop | Out-Null
                Write-MkBoxHost -m "Created folder: $name" -t "dn"
                $createdCount++
            }
            catch {
                Write-MkBoxHost -m "[MKBOX-ERR-NEWF-001] Folder create failed. Reason: '$name' could not be created. Fix: Check name validity, permissions, and path locks." -t "err"
                $skippedCount++
            }
        }
    }

    end {
        if ($skipMkBoxFolder) {
            return
        }

        Write-Host ""
        Write-MkBoxHost -m "Folder summary: created=$createdCount skipped=$skippedCount" -t "i"
        return
    }
}
