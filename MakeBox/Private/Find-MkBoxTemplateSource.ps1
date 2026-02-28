function Find-MkBoxTemplateSource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("file", "folder")]
        [string]$Instance,
        [Parameter(Mandatory = $true)]
        [string]$TemplateName
    )

    if (-not (Ensure-MkBoxUserTemplatesStore -CreateIfMissing)) {
        return $null
    }

    $projectsPath = Get-MkBoxUserTemplatesPath -PathType "projects"
    $filesPath = Get-MkBoxUserTemplatesPath -PathType "files"

    if ($Instance -eq "folder") {
        $userProjectPath = Join-Path -Path $projectsPath -ChildPath $TemplateName
        if (Test-Path -Path $userProjectPath -PathType Container) {
            return $userProjectPath
        }
    }
    else {
        $userFile = Get-ChildItem -Path $filesPath -File -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -eq $TemplateName } | Select-Object -First 1
        if ($null -ne $userFile) {
            return $userFile.FullName
        }
    }

    $moduleRoot = Split-Path -Path $PSScriptRoot -Parent
    $builtInTemplatesPath = Join-Path -Path $moduleRoot -ChildPath "Templates"

    if ($Instance -eq "folder") {
        $builtInProjectPath = Join-Path -Path $builtInTemplatesPath -ChildPath $TemplateName
        if (Test-Path -Path $builtInProjectPath -PathType Container) {
            return $builtInProjectPath
        }
    }
    else {
        $builtInFile = Get-ChildItem -Path $builtInTemplatesPath -File -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -eq $TemplateName } | Select-Object -First 1
        if ($null -ne $builtInFile) {
            return $builtInFile.FullName
        }
    }

    return $null
}
