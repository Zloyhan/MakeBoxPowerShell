function Invoke-MkBoxRoot {
    [CmdletBinding()]
    param(
        [Alias("f")]
        [switch]$Find,
        [Alias("m")]
        [switch]$Move
    )

    if ($Find -and $Move) {
        Write-MkBoxHost -m "Use either -find or -move, not both." -t "wr"
        return
    }

    if (-not $Find -and -not $Move) {
        $Find = $true
    }

    $workspaceRoot = Find-MkBoxWorkspaceRoot

    if ($Find) {
        if ($null -ne $workspaceRoot) {
            Write-MkBoxHost -m "Workspace is initialised in: $workspaceRoot" -t "i"
            return
        }

        Write-MkBoxHost -m "No workspace root found. Workspace is not initialised." -t "wr"
        return
    }

    if ($Move) {
        if ($null -eq $workspaceRoot) {
            Write-MkBoxHost -m "Workspace root does not exist. Please initialise workspace with init." -t "wr"
            return
        }

        Set-Location -Path $workspaceRoot
        Write-MkBoxHost -m "Moved back to workspace root: $workspaceRoot" -t "dn"
        return
    }
}
