function Ensure-MkBoxWorkspaceRoot {
    [CmdletBinding()]
    param(
        [string]$StartPath = (Get-Location).Path
    )

    $workspaceRoot = Find-MkBoxWorkspaceRoot -StartPath $StartPath
    if ($null -eq $workspaceRoot) {
        Write-MkBoxHost -m "No workspace root found. Please initialize with 'init' or move to a workspace directory." -t "wr"
        return $null
    }

    return $workspaceRoot
}
