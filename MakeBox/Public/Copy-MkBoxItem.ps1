function Copy-MkBoxItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,
        [Parameter(Mandatory = $true)]
        [string]$DestinationPath,
        [Alias("f")]
        [switch]$Force
    )

    if ($null -eq (Ensure-MkBoxWorkspaceRoot)) {
        return
    }

    if (-not (Test-Path -Path $SourcePath)) {
        Write-MkBoxHost -m "[MKBOX-ERR-CPY-001] Source not found. Reason: '$SourcePath' does not exist. Fix: Check path and run command again." -t "err"
        return
    }

    if (Test-MkBoxContainsRootMarker -Path $SourcePath) {
        Write-MkBoxHost -m "[MKBOX-ERR-CPY-002] Copy blocked. Reason: source contains '.mkboxroot'. Fix: Remove marker from source or choose a different source. Docs: $script:MkBoxDocsUrl" -t "err"
        return
    }

    if (Test-Path -Path $DestinationPath) {
        if (Test-MkBoxContainsRootMarker -Path $DestinationPath) {
            Write-MkBoxHost -m "[MKBOX-ERR-CPY-003] Copy blocked. Reason: destination contains '.mkboxroot'. Fix: Choose a destination outside workspace root marker path. Docs: $script:MkBoxDocsUrl" -t "err"
            return
        }
    }

    try {
        Copy-Item -Path $SourcePath -Destination $DestinationPath -Recurse -Force:$Force
        Write-MkBoxHost -m "Copied to: $DestinationPath" -t "dn"
    }
    catch {
        Write-MkBoxHost -m "[MKBOX-ERR-CPY-004] Copy failed. Reason: file system operation was rejected. Fix: Check permissions/locks/path validity and retry." -t "err"
    }

    return
}
