function Get-MkBoxUserTemplatesPath {
    [CmdletBinding()]
    param(
        [ValidateSet("makebox", "templates", "projects", "files")]
        [string]$PathType = "templates"
    )

    $documentsPath = [Environment]::GetFolderPath("MyDocuments")
    $makeBoxPath = Join-Path -Path $documentsPath -ChildPath "MakeBox"
    $templatesPath = Join-Path -Path $makeBoxPath -ChildPath "Templates"

    switch ($PathType) {
        "makebox" { return $makeBoxPath }
        "templates" { return $templatesPath }
        "projects" { return (Join-Path -Path $templatesPath -ChildPath "Projects") }
        "files" { return (Join-Path -Path $templatesPath -ChildPath "Files") }
        Default { return $templatesPath }
    }
}
