function Test-MkBoxContainsRootMarker {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -Path $Path)) {
        return $false
    }

    if (Test-Path -Path $Path -PathType Leaf) {
        return ((Split-Path -Path $Path -Leaf) -eq ".mkboxroot")
    }

    $rootMarkerPath = Join-Path -Path $Path -ChildPath ".mkboxroot"
    if (Test-Path -Path $rootMarkerPath -PathType Leaf) {
        return $true
    }

    $nestedMarker = Get-ChildItem -Path $Path -Recurse -File -Filter ".mkboxroot" -ErrorAction SilentlyContinue | Select-Object -First 1
    return ($null -ne $nestedMarker)
}
