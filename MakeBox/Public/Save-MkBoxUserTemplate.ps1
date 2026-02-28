function Save-MkBoxUserTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Alias("n")]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,
        [ValidateSet("project", "file")]
        [string]$Type,
        [Alias("f")]
        [switch]$Force
    )

    $currentDir = (Get-Location).Path
    $sourceName = Split-Path -Path $SourcePath -Leaf
    $hasPathPart = ($SourcePath -ne $sourceName)

    if ($hasPathPart -or [System.IO.Path]::IsPathRooted($SourcePath)) {
        Write-MkBoxHost -m "Use sibling source only. Provide file/folder name in current directory and run from that directory." -t "wr"
        return
    }

    $resolvedSourcePath = Join-Path -Path $currentDir -ChildPath $sourceName
    if (-not (Test-Path -Path $resolvedSourcePath)) {
        Write-MkBoxHost -m "No sibling file or folder named '$sourceName' found in current directory. Move (cd) to the sibling directory and retry." -t "wr"
        return
    }

    if (Test-MkBoxContainsRootMarker -Path $resolvedSourcePath) {
        Write-MkBoxHost -m "[MKBOX-ERR-SAVE-001] Save blocked. Reason: source contains '.mkboxroot'. Fix: Remove marker from source or choose another source. Docs: $script:MkBoxDocsUrl" -t "err"
        return
    }

    if (-not (Ensure-MkBoxUserTemplatesStore -CreateIfMissing)) {
        return
    }

    $templatesPath = Get-MkBoxUserTemplatesPath -PathType "templates"
    $projectsPath = Get-MkBoxUserTemplatesPath -PathType "projects"
    $filesPath = Get-MkBoxUserTemplatesPath -PathType "files"

    $sourceIsDirectory = Test-Path -Path $resolvedSourcePath -PathType Container
    $sourceIsFile = Test-Path -Path $resolvedSourcePath -PathType Leaf

    if (-not $PSBoundParameters.ContainsKey("Type")) {
        if ($sourceIsDirectory) { $Type = "project" }
        if ($sourceIsFile) { $Type = "file" }
    }

    if (($Type -eq "project") -and (-not $sourceIsDirectory)) {
        Write-MkBoxHost -m "[MKBOX-ERR-SAVE-002] Invalid source type. Reason: 'project' requires a folder source. Fix: Use a folder source or set -Type file." -t "err"
        return
    }

    if (($Type -eq "file") -and (-not $sourceIsFile)) {
        Write-MkBoxHost -m "[MKBOX-ERR-SAVE-003] Invalid source type. Reason: 'file' requires a file source. Fix: Use a file source or set -Type project." -t "err"
        return
    }

    if ($Type -eq "project") {
        $destinationPath = Join-Path -Path $projectsPath -ChildPath $Name
    }
    else {
        $sourceExtension = [System.IO.Path]::GetExtension($resolvedSourcePath)
        $destinationPath = Join-Path -Path $filesPath -ChildPath "$Name$sourceExtension"
    }

    if (Test-Path -Path $destinationPath) {
        if (-not $Force) {
            Write-MkBoxHost -m "Confirm overwrite template: $destinationPath" -t "?"
            if (-not $PSCmdlet.ShouldContinue("Overwrite existing template?", "Confirm overwrite")) {
                Write-MkBoxHost -m "Skipped saving template: $Name" -t "wr"
                return
            }
        }

        Remove-Item -Path $destinationPath -Recurse -Force
    }

    try {
        Copy-Item -Path $resolvedSourcePath -Destination $destinationPath -Recurse -Force
        Write-MkBoxHost -m "Template saved: $Name ($Type)" -t "dn"
    }
    catch {
        Write-MkBoxHost -m "[MKBOX-ERR-SAVE-004] Save failed. Reason: template copy operation was rejected. Fix: Check permissions, locks, and destination path validity." -t "err"
    }

    return
}
