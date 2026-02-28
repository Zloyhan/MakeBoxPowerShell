function Get-MkBoxTemplatesTree {
    [CmdletBinding()]
    param()

    if (-not (Ensure-MkBoxUserTemplatesStore -CreateIfMissing)) {
        return
    }

    $templatesPath = Get-MkBoxUserTemplatesPath -PathType "templates"

    $rootItems = Get-ChildItem -Path $templatesPath -Force -ErrorAction SilentlyContinue
    if ($null -eq $rootItems -or $rootItems.Count -eq 0) {
        Write-MkBoxHost -m "No templates found." -t "wr"
        return
    }

    Write-MkBoxHost -m "Current templates:" -t "i"
    $treeOutput = tree $templatesPath /A /F
    if ($null -eq $treeOutput -or $treeOutput.Count -eq 0) {
        return
    }

    if ($treeOutput.Count -gt 3) {
        $treeOutput | Select-Object -Skip 3
    }
    else {
        $treeOutput
    }

    return
}
