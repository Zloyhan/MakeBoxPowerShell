function Get-MkBoxWorkspaceRoot {
    
    [CmdletBinding()]
    param()

    $workspaceRoot = Find-MkBoxWorkspaceRoot

    if ($null -ne $workspaceRoot) {
        Write-MkBoxHost -m "Workspace is initialised in: $workspaceRoot" -t "i"
        return $workspaceRoot
    }

    Write-MkBoxHost -m "No workspace root found. Workspace is not initialised." -t "wr"
    return
}
