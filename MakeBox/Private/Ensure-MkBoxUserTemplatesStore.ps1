function Ensure-MkBoxUserTemplatesStore {
    [CmdletBinding()]
    param(
        [switch]$CreateIfMissing
    )

    $docsUrl = if ($script:MkBoxDocsUrl) { $script:MkBoxDocsUrl } else { "https://github.com/Zloyhan/MakeBoxPS/blob/main/docs/DOCUMENTATION.md" }
    $makeBoxPath = Get-MkBoxUserTemplatesPath -PathType "makebox"
    $templatesPath = Get-MkBoxUserTemplatesPath -PathType "templates"
    $projectsPath = Get-MkBoxUserTemplatesPath -PathType "projects"
    $filesPath = Get-MkBoxUserTemplatesPath -PathType "files"

    if (Test-Path -Path $makeBoxPath -PathType Leaf) {
        Write-MkBoxHost -m "[MKBOX-EC-001] User template base path is a file. Reason: '$makeBoxPath' must be a directory. Fix: Rename/remove that file, then rerun command. Docs: $docsUrl" -t "err"
        return $false
    }

    if (Test-Path -Path $templatesPath -PathType Leaf) {
        Write-MkBoxHost -m "[MKBOX-EC-002] Templates path is a file. Reason: '$templatesPath' must be a directory. Fix: Rename/remove that file, then rerun command. Docs: $docsUrl" -t "err"
        return $false
    }

    if ($CreateIfMissing) {
        foreach ($path in @($makeBoxPath, $templatesPath, $projectsPath, $filesPath)) {
            if (-not (Test-Path -Path $path -PathType Container)) {
                New-Item -Path $path -ItemType Directory | Out-Null
                Write-MkBoxHost -m "Created: $path" -t "dn"
            }
        }

        return $true
    }

    if (-not (Test-Path -Path $templatesPath -PathType Container)) {
        Write-MkBoxHost -m "[MKBOX-EC-003] Templates store not found. Reason: '$templatesPath' does not exist. Fix: Run command again to auto-create store or run 'doctor'. Docs: $docsUrl" -t "wr"
        return $false
    }

    return $true
}
