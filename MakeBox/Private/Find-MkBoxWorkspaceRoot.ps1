function Find-MkBoxWorkspaceRoot {
    [CmdletBinding()]
    param(
        [string]$StartPath = (Get-Location).Path,
        [switch]$ReturnMarkerPath
    )

    $current = Get-Item -Path $StartPath

    while ($null -ne $current) {
        $markerPath = Join-Path -Path $current.FullName -ChildPath ".mkboxroot"
        if (Test-Path -Path $markerPath -PathType Leaf) {
            if ($ReturnMarkerPath) {
                return $markerPath
            }

            return $current.FullName
        }

        $current = $current.Parent
    }

    return $null
}
