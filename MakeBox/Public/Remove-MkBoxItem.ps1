function Remove-MkBoxItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("n", "Name")]
        [string[]]$ItemName,
        [Alias("f")]
        [switch]$Force
    )

    begin {
        if ($null -eq (Ensure-MkBoxWorkspaceRoot)) {
            $skipMkBoxRemove = $true
            return
        }

        $skipMkBoxRemove = $false
        $suspendMkBoxRemove = $false
        $currentDir = (Get-Location).Path
        $deletedCount = 0
        $skippedCount = 0
        $notFoundCount = 0
    }

    process {
        if ($skipMkBoxRemove) {
            return
        }

        if ($suspendMkBoxRemove) {
            return
        }

        foreach ($name in $ItemName) {
            if ($suspendMkBoxRemove) {
                break
            }

            if (-not (Test-MkBoxSafeRelativeName -Name $name)) {
                Write-MkBoxHost -m "[MKBOX-ERR-RM-001] Remove blocked. Reason: '$name' is not a safe relative name. Fix: Use only relative names without drive/UNC/.. traversal." -t "err"
                $skippedCount++
                continue
            }

            $targetPath = Join-Path -Path $currentDir -ChildPath $name

            if (-not (Test-Path -Path $targetPath)) {
                Write-MkBoxHost -m "Item not found: $name" -t "wr"
                $notFoundCount++
                continue
            }

            if (-not $Force) {
                $confirmationAction = "Y"
                while ($true) {
                    Write-MkBoxHost -m "Confirm removal: $name -> [Y] Yes (default)  [N] No  [S] Suspend  [?] Help" -t "?"
                    $choice = Read-Host
                    if ([string]::IsNullOrWhiteSpace($choice)) {
                        $choice = "Y"
                    }

                    switch ($choice.Trim().ToUpperInvariant()) {
                        "Y" {
                            $confirmationAction = "Y"
                            break
                        }
                        "N" {
                            $confirmationAction = "N"
                            break
                        }
                        "S" {
                            $confirmationAction = "S"
                            break
                        }
                        "?" {
                            Write-Host "         Choose Y to remove, N to skip, S to suspend remaining removals." -ForegroundColor White
                            continue
                        }
                        Default {
                            Write-Host "         Invalid choice. Use Y, N, S, or ?." -ForegroundColor White
                            continue
                        }
                    }

                    break
                }

                if ($confirmationAction -eq "N") {
                    Write-MkBoxHost -m "Skipped by user: $name" -t "wr"
                    $skippedCount++
                    continue
                }

                if ($confirmationAction -eq "S") {
                    Write-MkBoxHost -m "Removal suspended by user." -t "wr"
                    $suspendMkBoxRemove = $true
                    $skippedCount++
                    continue
                }
            }

            try {
                Remove-Item -Path $targetPath -Recurse -Force -ErrorAction Stop
                Write-MkBoxHost -m "Removed item: $name" -t "dn"
                $deletedCount++
            }
            catch {
                Write-MkBoxHost -m "[MKBOX-ERR-RM-002] Remove failed. Reason: '$name' could not be deleted. Fix: Check permissions, locks, and read-only attributes." -t "err"
                $skippedCount++
            }
        }
    }

    end {
        if ($skipMkBoxRemove) {
            return
        }

        Write-Host ""
        Write-MkBoxHost -m "Remove summary: deleted=$deletedCount skipped=$skippedCount not-found=$notFoundCount" -t "i"
        return
    }
}
