@{
    RootModule = 'MakeBox.psm1'
    ModuleVersion = '1.3.10'
    GUID = '7fedd8e4-cc92-4042-9c01-7f8d2ca9450c'
    Author = 'Emirhan Bilgili'
    CompanyName = ''
    Copyright = '(c) Emirhan Bilgili. Licensed under the Apache License 2.0.'
    Description = 'PowerShell Module for easily scaffolding and managing project files and folders in an easy-to-use, casual way.'

    PowerShellVersion = '7.5'
    CompatiblePSEditions = @('Core')

    FunctionsToExport = @(
        'Initialize-MkBoxWorkspace',
        'Invoke-MkBoxRoot',
        'Get-MkBoxWorkspaceRoot',
        'Invoke-MkBoxNew',
        'Invoke-MkBoxGet',
        'Invoke-MkBoxGetFolder',
        'Invoke-MkBoxGetFile',
        'Invoke-MkAliasInit',
        'Invoke-MkAliasRoot',
        'Invoke-MkAliasGetProject',
        'Invoke-MkAliasGetFile',
        'Invoke-MkAliasNewFolder',
        'Invoke-MkAliasNewFile',
        'Invoke-MkAliasRemove',
        'Invoke-MkAliasCopy',
        'Invoke-MkAliasSave',
        'Invoke-MkAliasDeleteTemplate',
        'Invoke-MkAliasClearTemplates',
        'Invoke-MkAliasListTemplates',
        'Invoke-MkAliasDoctor',
        'Invoke-MkAliasHelp',
        'Invoke-MkAliasAlias',
        'New-MkBoxFolder',
        'New-MkBoxFile',
        'Remove-MkBoxItem',
        'Copy-MkBoxItem',
        'Save-MkBoxUserTemplate',
        'Remove-MkBoxUserTemplate',
        'Clear-MkBoxUserTemplates',
        'Get-MkBoxTemplatesTree',
        'Invoke-MkBoxDoctor',
        'Show-MkBoxHelp',
        'Show-MkBoxAliases',
        'mkbox'
    )

    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @(
        'mkinit',
        'mkroot',
        'mkgetproject',
        'mkgetfile',
        'mkfolder',
        'mkfile',
        'mkrm',
        'mkcopy',
        'mksave',
        'mkdel',
        'mkclr',
        'mkls',
        'mkdoc',
        'mkhelp',
        'mkalias'
    )

    PrivateData = @{
        PSData = @{
            Tags = @('MakeBox', 'Workspace', 'Templates', 'Productivity')
            LicenseUri = 'https://www.apache.org/licenses/LICENSE-2.0'
            ProjectUri = 'https://github.com/Zloyhan/MakeBoxPS'
            Contact = 'e.bilgili@student.tue.nl'
            ReleaseNotes = 'v1.3.10 fix: mkls/lst now includes file templates in tree output and mkfile/mkfolder now report file-vs-folder name collisions correctly.'
        }
    }
}
