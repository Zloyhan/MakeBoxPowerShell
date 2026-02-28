function Invoke-MkBoxDoctor {
    [CmdletBinding()]
    param()

    $fixedCount = 0
    $warnCount = 0

    $workspaceRoot = Find-MkBoxWorkspaceRoot
    if ($null -eq $workspaceRoot) {
        Write-MkBoxHost -m "Workspace root not found from current directory. Run 'init' to initialise workspace." -t "wr"
        $warnCount++
    }
    else {
        Write-MkBoxHost -m "Workspace root found: $workspaceRoot" -t "dn"

        $commonPath = Join-Path -Path $workspaceRoot -ChildPath "common"
        if (-not (Test-Path -Path $commonPath -PathType Container)) {
            New-Item -Path $workspaceRoot -ItemType Directory -Name "common" | Out-Null
            Write-MkBoxHost -m "Fixed missing common folder: $commonPath" -t "dn"
            $fixedCount++
        }
        else {
            Write-MkBoxHost -m "Common folder exists: $commonPath" -t "dn"
        }
    }

    if (Ensure-MkBoxUserTemplatesStore -CreateIfMissing) {
        Write-MkBoxHost -m "User templates store is ready in Documents." -t "dn"
    }
    else {
        Write-MkBoxHost -m "[MKBOX-ERR-DOCTOR-001] Doctor check failed. Reason: user templates store validation did not pass. Fix: Follow printed edge-case guidance and rerun doctor." -t "err"
        $warnCount++
    }

    Write-MkBoxHost -m "Doctor summary: fixed=$fixedCount warnings=$warnCount" -t "i"
    return
}
