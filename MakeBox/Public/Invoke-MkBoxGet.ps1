function Invoke-MkBoxGet {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet("file", "project")]
        [string]$Instance,
        [Parameter(Position = 1)]
        [Alias("t", "Template")]
        [string]$TemplateName,
        [Parameter(Position = 2, ValueFromRemainingArguments = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("n", "Name")]
        [string[]]$TargetName
    )

    begin {
        if ([string]::IsNullOrWhiteSpace($Instance)) {
            Write-MkBoxHost -m "Please specify template type and name. Usage: mkbox get <file|project> <templateName> [targetName ...]" -t "wr"
            $skipMkBoxGet = $true
            return
        }

        if ([string]::IsNullOrWhiteSpace($TemplateName)) {
            Write-MkBoxHost -m "Please specify a template name. Example: mkbox get project C MyProject" -t "wr"
            $skipMkBoxGet = $true
            return
        }

        if ($null -eq (Ensure-MkBoxWorkspaceRoot)) {
            $skipMkBoxGet = $true
            return
        }

        $skipMkBoxGet = $false
        $currentDir = (Get-Location).Path
        $createdCount = 0
        $skippedCount = 0
        $resolvedInstance = if ($Instance -eq "project") { "folder" } else { "file" }
        $templateSourcePath = Find-MkBoxTemplateSource -Instance $resolvedInstance -TemplateName $TemplateName

        if ($null -eq $templateSourcePath) {
            Write-MkBoxHost -m "Template not found: $TemplateName ($Instance)" -t "wr"
            $skipMkBoxGet = $true
            return
        }

        if (($resolvedInstance -eq "folder") -and (Test-MkBoxContainsRootMarker -Path $templateSourcePath)) {
            Write-MkBoxHost -m "[MKBOX-EC-004] Folder template contains root marker. Reason: '$TemplateName' includes '.mkboxroot'. Fix: Remove '.mkboxroot' from template source and retry. Docs: $script:MkBoxDocsUrl" -t "err"
            $skipMkBoxGet = $true
            return
        }
    }

    process {
        if ($skipMkBoxGet) {
            return
        }

        $requestedNames = $TargetName
        if ($null -eq $requestedNames -or $requestedNames.Count -eq 0) {
            if ($Instance -eq "project") {
                $requestedNames = @($TemplateName)
            }
            else {
                $requestedNames = @((Split-Path -Path $templateSourcePath -Leaf))
            }
        }

        foreach ($name in $requestedNames) {
            if ([string]::IsNullOrWhiteSpace($name)) {
                Write-MkBoxHost -m "Skipped empty target name." -t "wr"
                $skippedCount++
                continue
            }

            $targetPath = Join-Path -Path $currentDir -ChildPath $name
            if (Test-Path -Path $targetPath) {
                Write-MkBoxHost -m "Target already exists, skipped: $name" -t "wr"
                $skippedCount++
                continue
            }

            try {
                Copy-Item -Path $templateSourcePath -Destination $targetPath -Recurse -Force -ErrorAction Stop
                Write-MkBoxHost -m "Created from template: $name" -t "dn"
                $createdCount++
            }
            catch {
                Write-MkBoxHost -m "[MKBOX-ERR-GET-001] Get failed. Reason: target '$name' could not be created from template. Fix: Check path permissions, locks, and target name validity." -t "err"
                $skippedCount++
            }
        }
    }

    end {
        if ($skipMkBoxGet) {
            return
        }

        Write-Host ""
        Write-MkBoxHost -m "Get summary: created=$createdCount skipped=$skippedCount" -t "i"
        return
    }
}
