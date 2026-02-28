function Remove-MkBoxUserTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Alias("n")]
        [string]$Name,
        [ValidateSet("project", "file", "auto")]
        [string]$Type = "auto",
        [Alias("f")]
        [switch]$Force
    )

    $projectsPath = Get-MkBoxUserTemplatesPath -PathType "projects"
    $filesPath = Get-MkBoxUserTemplatesPath -PathType "files"

    if (-not (Ensure-MkBoxUserTemplatesStore -CreateIfMissing)) {
        return
    }

    $targets = @()

    if (($Type -eq "project") -or ($Type -eq "auto")) {
        $projectPath = Join-Path -Path $projectsPath -ChildPath $Name
        if (Test-Path -Path $projectPath) {
            $targets += $projectPath
        }
    }

    if (($Type -eq "file") -or ($Type -eq "auto")) {
        $fileMatches = Get-ChildItem -Path $filesPath -File -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -eq $Name }
        foreach ($match in $fileMatches) {
            $targets += $match.FullName
        }
    }

    if ($targets.Count -eq 0) {
        Write-MkBoxHost -m "Template not found: $Name" -t "wr"
        return
    }

    foreach ($target in $targets) {
        if (-not $Force) {
            Write-MkBoxHost -m "Confirm remove template: $target" -t "?"
            if (-not $PSCmdlet.ShouldContinue("Remove template '$target'?", "Confirm remove")) {
                Write-MkBoxHost -m "Skipped: $target" -t "wr"
                continue
            }
        }

        try {
            Remove-Item -Path $target -Recurse -Force
            Write-MkBoxHost -m "Removed template: $target" -t "dn"
        }
        catch {
            Write-MkBoxHost -m "[MKBOX-ERR-DELT-001] Remove template failed. Reason: target could not be deleted. Fix: Check permissions, file locks, and template path state." -t "err"
        }
    }

    return
}
