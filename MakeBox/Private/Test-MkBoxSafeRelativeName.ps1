function Test-MkBoxSafeRelativeName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return $false
    }

    if ([System.IO.Path]::IsPathRooted($Name)) {
        return $false
    }

    if ($Name -match '^[a-zA-Z]:') {
        return $false
    }

    if ($Name.StartsWith('\\')) {
        return $false
    }

    $parts = $Name -split '[\\/]'
    if ($parts -contains '..') {
        return $false
    }

    return $true
}
