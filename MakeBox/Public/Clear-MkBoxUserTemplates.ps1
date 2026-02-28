function Clear-MkBoxUserTemplates {
    [CmdletBinding()]
    param(
        [Alias("f")]
        [switch]$Force
    )

    $templatesPath = Get-MkBoxUserTemplatesPath -PathType "templates"

    if (-not (Ensure-MkBoxUserTemplatesStore -CreateIfMissing)) {
        return
    }

    if (-not $Force) {
        Write-MkBoxHost -m "Confirm clear all user templates." -t "?"
        if (-not $PSCmdlet.ShouldContinue("Delete all user templates?", "Confirm clear")) {
            Write-MkBoxHost -m "Clear templates cancelled." -t "wr"
            return
        }
    }

    try {
        Remove-Item -Path $templatesPath -Recurse -Force
        Write-MkBoxHost -m "All user templates removed." -t "dn"
    }
    catch {
        Write-MkBoxHost -m "[MKBOX-ERR-CLRT-001] Clear templates failed. Reason: templates directory could not be removed. Fix: Check permissions/locks and retry." -t "err"
    }

    return
}
