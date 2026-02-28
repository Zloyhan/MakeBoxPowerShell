 $script:MkBoxVersion = "v1.3.10"
 $script:MkBoxCreatedOn = "2026-02-27"
$script:MkBoxDocsUrl = "https://github.com/Zloyhan/MakeBoxPS/blob/main/docs/DOCUMENTATION.md"
$script:MkBoxProjectUrl = "https://github.com/Zloyhan/MakeBoxPS"

$privateScripts = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "Private") -Filter "*.ps1" -File
foreach ($script in $privateScripts) {
    . $script.FullName
}

$publicScripts = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "Public") -Filter "*.ps1" -File
foreach ($script in $publicScripts) {
    . $script.FullName
}

function Show-MkBoxCommandHelp {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CommandName
    )

    $pad = "         "
    $cmd = $CommandName.ToLowerInvariant()

    switch ($cmd) {
        "init" {
            Write-MkBoxHost -m "Command: init | Initialize workspace in current directory." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox init" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  (none)    Creates .mkboxroot and common folder; ensures user template store." -ForegroundColor White
            return
        }
        "root" {
            Write-MkBoxHost -m "Command: root | Find workspace root or move to it." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox root [-find|-f] [-move|-m]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  -find,-f  Finds nearest parent/current workspace root (default)." -ForegroundColor White
            Write-Host "${pad}  -move,-m  Changes directory to resolved workspace root." -ForegroundColor White
            return
        }
        "new" {
            Write-MkBoxHost -m "Command: new | Create empty file(s) or folder(s)." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox new <file|folder> <name1> [name2 ...]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  <file|folder>   Selects item type to create." -ForegroundColor White
            Write-Host "${pad}  <name...>       One or more target names; supports pipeline to command function." -ForegroundColor White
            return
        }
        "get" {
            Write-MkBoxHost -m "Command: get | Create item(s) from template." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox get <file|project> <templateName> [targetName ...]" -ForegroundColor White
            Write-Host "${pad}       mkgetproject <templateName> [targetName ...]" -ForegroundColor White
            Write-Host "${pad}       mkgetfile <templateName> [targetName ...]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  <file|project>   Selects template type." -ForegroundColor White
            Write-Host "${pad}  <templateName>   Template key to resolve (user templates first, then built-in)." -ForegroundColor White
            Write-Host "${pad}  [targetName...]  Optional output names; if omitted defaults are used." -ForegroundColor White
            return
        }
        "rm" {
            Write-MkBoxHost -m "Command: rm | Remove workspace items safely." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox rm <name1> [name2 ...] [-Force]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  <name...>   Relative item names to remove recursively." -ForegroundColor White
            Write-Host "${pad}  -Force      Skips confirmation prompts." -ForegroundColor White
            return
        }
        "copy" {
            Write-MkBoxHost -m "Command: copy | Copy file/folder in workspace." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox copy <sourcePath> <destinationPath> [-Force]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  <sourcePath>       Source file/folder path." -ForegroundColor White
            Write-Host "${pad}  <destinationPath>  Destination path." -ForegroundColor White
            Write-Host "${pad}  -Force             Overwrites when supported by Copy-Item." -ForegroundColor White
            return
        }
        "save" {
            Write-MkBoxHost -m "Command: savet | Save sibling file/folder as user template." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox savet -Name <templateName> -SourcePath <siblingName> [-Type project|file] [-Force]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  -Name        Template name to store." -ForegroundColor White
            Write-Host "${pad}  -SourcePath  Sibling file/folder name in current directory." -ForegroundColor White
            Write-Host "${pad}  -Type        Optional: project or file (auto-detected when omitted)." -ForegroundColor White
            Write-Host "${pad}  -Force       Overwrites existing template without prompt." -ForegroundColor White
            return
        }
        "del" {
            Write-MkBoxHost -m "Command: delt | Remove user template(s)." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox delt -Name <templateName> [-Type auto|project|file] [-Force]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  -Name   Template name to remove." -ForegroundColor White
            Write-Host "${pad}  -Type   Match mode: auto, project, or file." -ForegroundColor White
            Write-Host "${pad}  -Force  Skips confirmation prompt." -ForegroundColor White
            return
        }
        "clrt" {
            Write-MkBoxHost -m "Command: clrt | Clear all user templates." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox clrt [-Force]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  -Force  Clears templates without confirmation prompt." -ForegroundColor White
            return
        }
        "lst" {
            Write-MkBoxHost -m "Command: lst | List template store as tree." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox lst" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  (none)  Prints templates store path and tree view." -ForegroundColor White
            return
        }
        "doctor" {
            Write-MkBoxHost -m "Command: doctor | Check and auto-fix core environment state." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox doctor" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  (none)  Verifies workspace root/common and user templates store." -ForegroundColor White
            return
        }
        "help" {
            Write-MkBoxHost -m "Command: help | Show general help or command-specific help." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox help [command]" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  [command]  Optional command name (init/root/new/get/rm/copy/savet/delt/clrt/lst/doctor/alias)." -ForegroundColor White
            return
        }
        "alias" {
            Write-MkBoxHost -m "Command: alias | Show MakeBox aliases." -t "i"
            Write-Host ""
            Write-Host "${pad}Usage: mkbox alias" -ForegroundColor White
            Write-Host ""
            Write-Host "${pad}Parameters:" -ForegroundColor White
            Write-Host "${pad}  (none)  Prints available MakeBox aliases and mapped commands." -ForegroundColor White
            return
        }
        Default {
            Write-MkBoxHost -m "Unknown command help target: $CommandName" -t "wr"
            Write-Host "         Try: mkbox help" -ForegroundColor White
            return
        }
    }
}

function Show-MkBoxHelp {
    param(
        [string]$CommandName
    )

    if (-not [string]::IsNullOrWhiteSpace($CommandName)) {
        Show-MkBoxCommandHelp -CommandName $CommandName
        return
    }

    $pad = "         "
    Write-Host "${pad}Usage: mkbox <command> [args]" -ForegroundColor White
    Write-Host ""
    Write-Host "${pad}Available commands:" -ForegroundColor White
    Write-Host "${pad}  init      Initialize workspace" -ForegroundColor White
    Write-Host "${pad}  root      Find or move to workspace root" -ForegroundColor White
    Write-Host "${pad}  new       Create new empty file/folder" -ForegroundColor White
    Write-Host "${pad}  get       Create file/folder from template" -ForegroundColor White
    Write-Host "${pad}  rm        Remove workspace items" -ForegroundColor White
    Write-Host "${pad}  copy      Copy file/folder in workspace" -ForegroundColor White
    Write-Host "${pad}  savet     Save user template" -ForegroundColor White
    Write-Host "${pad}  delt      Remove user template" -ForegroundColor White
    Write-Host "${pad}  clrt      Clear all user templates" -ForegroundColor White
    Write-Host "${pad}  lst       List templates as tree" -ForegroundColor White
    Write-Host "${pad}  doctor    Check/fix workspace and template store" -ForegroundColor White
    Write-Host "${pad}  alias     Show aliases" -ForegroundColor White
    Write-Host "${pad}  help      Show this help" -ForegroundColor White
    Write-Host ""
    Write-Host "${pad}Check official documentation for more details: $script:MkBoxProjectUrl" -ForegroundColor White
}

function Show-MkBoxAliases {
    $pad = "         "
    Write-MkBoxHost -m "MakeBox aliases:" -t "i"
    Write-Host ""
    Write-Host "${pad}mkinit      -> mkbox init" -ForegroundColor White
    Write-Host "${pad}mkroot      -> mkbox root" -ForegroundColor White
    Write-Host "${pad}mkgetproject -> mkbox get project" -ForegroundColor White
    Write-Host "${pad}mkgetfile   -> mkbox get file" -ForegroundColor White
    Write-Host "${pad}mkfolder    -> mkbox new folder" -ForegroundColor White
    Write-Host "${pad}mkfile      -> mkbox new file" -ForegroundColor White
    Write-Host "${pad}mkrm        -> mkbox rm" -ForegroundColor White
    Write-Host "${pad}mkcopy      -> mkbox copy" -ForegroundColor White
    Write-Host "${pad}mksave      -> mkbox savet" -ForegroundColor White
    Write-Host "${pad}mkdel       -> mkbox delt" -ForegroundColor White
    Write-Host "${pad}mkclr       -> mkbox clrt" -ForegroundColor White
    Write-Host "${pad}mkls        -> mkbox lst" -ForegroundColor White
    Write-Host "${pad}mkdoc       -> mkbox doctor" -ForegroundColor White
    Write-Host "${pad}mkhelp      -> mkbox help" -ForegroundColor White
    Write-Host "${pad}mkalias     -> mkbox alias" -ForegroundColor White
    Write-Host ""
    Write-Host "${pad}Check official documentation for more details: $script:MkBoxProjectUrl" -ForegroundColor White
}

function Show-MkBoxInfo {
    $pad = "         "
    Write-MkBoxHost -m "MakeBox Tools for PowerShell 7.5+ | Version: $script:MkBoxVersion" -t "i"
    Write-Host "${pad}Copyright (c) Emirhan Bilgili. Licensed under the Apache License 2.0." -ForegroundColor White
    Write-Host ""
    Write-Host "${pad}For commands and documentation, type: mkbox help" -ForegroundColor White
}

function mkbox {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Command,
        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]$Arguments
    )

    if (($null -eq $Arguments) -or (($Arguments.Count -eq 1) -and ($null -eq $Arguments[0]))) {
        $Arguments = @()
    }

    function Invoke-MkBoxCommand {
        param(
            [Parameter(Mandatory = $true)]
            [scriptblock]$Action,
            [string]$Usage
        )

        try {
            & $Action
        }
        catch [System.Management.Automation.ParameterBindingException] {
            Write-MkBoxHost -m "Invalid usage. $($_.Exception.Message)" -t "wr"
            if (-not [string]::IsNullOrWhiteSpace($Usage)) {
                Write-Host "         Usage: $Usage" -ForegroundColor White
            }
            Write-Host "         For more details: mkbox help" -ForegroundColor White
        }
    }

    Write-Host ""
    try {
        switch ($Command) {
            "init" { Invoke-MkBoxCommand -Action { Initialize-MkBoxWorkspace @Arguments } -Usage "mkbox init"; return }
            "root" { Invoke-MkBoxCommand -Action { Invoke-MkBoxRoot @Arguments } -Usage "mkbox root [-find|-f] [-move|-m]"; return }
            "new" { Invoke-MkBoxCommand -Action { Invoke-MkBoxNew @Arguments } -Usage "mkbox new <file|folder> <name1> [name2 ...]"; return }
            "get" { Invoke-MkBoxCommand -Action { Invoke-MkBoxGet @Arguments } -Usage "mkbox get <file|project> <templateName> [targetName ...]"; return }
            "newf" { Invoke-MkBoxCommand -Action { New-MkBoxFolder @Arguments } -Usage "mkbox mkfolder <name1> [name2 ...]"; return }
            "mkfolder" { Invoke-MkBoxCommand -Action { New-MkBoxFolder @Arguments } -Usage "mkbox mkfolder <name1> [name2 ...]"; return }
            "mkfile" { Invoke-MkBoxCommand -Action { New-MkBoxFile @Arguments } -Usage "mkbox mkfile <name1> [name2 ...]"; return }
            "rm" { Invoke-MkBoxCommand -Action { Remove-MkBoxItem @Arguments } -Usage "mkbox rm <name1> [name2 ...] [-Force]"; return }
            "copy" { Invoke-MkBoxCommand -Action { Copy-MkBoxItem @Arguments } -Usage "mkbox copy <sourcePath> <destinationPath> [-Force]"; return }
            "save" { Invoke-MkBoxCommand -Action { Save-MkBoxUserTemplate @Arguments } -Usage "mkbox savet -Name <templateName> -SourcePath <siblingName> [-Type project|file] [-Force]"; return }
            "savet" { Invoke-MkBoxCommand -Action { Save-MkBoxUserTemplate @Arguments } -Usage "mkbox savet -Name <templateName> -SourcePath <siblingName> [-Type project|file] [-Force]"; return }
            "del" { Invoke-MkBoxCommand -Action { Remove-MkBoxUserTemplate @Arguments } -Usage "mkbox delt -Name <templateName> [-Type auto|project|file] [-Force]"; return }
            "delt" { Invoke-MkBoxCommand -Action { Remove-MkBoxUserTemplate @Arguments } -Usage "mkbox delt -Name <templateName> [-Type auto|project|file] [-Force]"; return }
            "clrt" { Invoke-MkBoxCommand -Action { Clear-MkBoxUserTemplates @Arguments } -Usage "mkbox clrt [-Force]"; return }
            "lst" { Invoke-MkBoxCommand -Action { Get-MkBoxTemplatesTree @Arguments } -Usage "mkbox lst"; return }
            "doctor" { Invoke-MkBoxCommand -Action { Invoke-MkBoxDoctor @Arguments } -Usage "mkbox doctor"; return }
            "alias" { Show-MkBoxAliases @Arguments; return }
            "help" { Show-MkBoxHelp @Arguments; return }
            Default {
                if ([string]::IsNullOrWhiteSpace($Command)) {
                    Show-MkBoxInfo
                }
                else {
                    Show-MkBoxHelp
                }
                return
            }
        }
    }
    finally {
        Write-Host ""
    }
}

function Invoke-MkBoxGetFolder {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]$Arguments
    )

    Invoke-MkBoxGet project @Arguments
}

function Invoke-MkBoxGetFile {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]$Arguments
    )

    Invoke-MkBoxGet file @Arguments
}

function Invoke-MkAliasInit {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox init @Arguments
}

function Invoke-MkAliasRoot {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox root @Arguments
}

function Invoke-MkAliasGetProject {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox get project @Arguments
}

function Invoke-MkAliasGetFile {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox get file @Arguments
}

function Invoke-MkAliasNewFolder {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox new folder @Arguments
}

function Invoke-MkAliasNewFile {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox new file @Arguments
}

function Invoke-MkAliasRemove {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox rm @Arguments
}

function Invoke-MkAliasCopy {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox copy @Arguments
}

function Invoke-MkAliasSave {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox savet @Arguments
}

function Invoke-MkAliasDeleteTemplate {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox delt @Arguments
}

function Invoke-MkAliasClearTemplates {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox clrt @Arguments
}

function Invoke-MkAliasListTemplates {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox lst @Arguments
}

function Invoke-MkAliasDoctor {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox doctor @Arguments
}

function Invoke-MkAliasHelp {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox help @Arguments
}

function Invoke-MkAliasAlias {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)
    mkbox alias @Arguments
}

foreach ($legacyAlias in @("mknew", "mkget", "mkgetfolder", "mkgetproj")) {
    if (Test-Path -Path ("Alias:" + $legacyAlias)) {
        Remove-Item -Path ("Alias:" + $legacyAlias) -Force -ErrorAction SilentlyContinue
    }
}

Set-Alias -Name mkinit -Value Invoke-MkAliasInit -Scope Global -Force
Set-Alias -Name mkroot -Value Invoke-MkAliasRoot -Scope Global -Force
Set-Alias -Name mkgetproject -Value Invoke-MkAliasGetProject -Scope Global -Force
Set-Alias -Name mkgetfile -Value Invoke-MkAliasGetFile -Scope Global -Force
Set-Alias -Name mkfolder -Value Invoke-MkAliasNewFolder -Scope Global -Force
Set-Alias -Name mkfile -Value Invoke-MkAliasNewFile -Scope Global -Force
Set-Alias -Name mkrm -Value Invoke-MkAliasRemove -Scope Global -Force
Set-Alias -Name mkcopy -Value Invoke-MkAliasCopy -Scope Global -Force
Set-Alias -Name mksave -Value Invoke-MkAliasSave -Scope Global -Force
Set-Alias -Name mkdel -Value Invoke-MkAliasDeleteTemplate -Scope Global -Force
Set-Alias -Name mkclr -Value Invoke-MkAliasClearTemplates -Scope Global -Force
Set-Alias -Name mkls -Value Invoke-MkAliasListTemplates -Scope Global -Force
Set-Alias -Name mkdoc -Value Invoke-MkAliasDoctor -Scope Global -Force
Set-Alias -Name mkhelp -Value Invoke-MkAliasHelp -Scope Global -Force
Set-Alias -Name mkalias -Value Invoke-MkAliasAlias -Scope Global -Force

Export-ModuleMember -Function `
    Initialize-MkBoxWorkspace, `
    Invoke-MkBoxRoot, `
    Get-MkBoxWorkspaceRoot, `
    Invoke-MkBoxNew, `
    Invoke-MkBoxGet, `
    Invoke-MkBoxGetFolder, `
    Invoke-MkBoxGetFile, `
    Invoke-MkAliasInit, `
    Invoke-MkAliasRoot, `
    Invoke-MkAliasGetProject, `
    Invoke-MkAliasGetFile, `
    Invoke-MkAliasNewFolder, `
    Invoke-MkAliasNewFile, `
    Invoke-MkAliasRemove, `
    Invoke-MkAliasCopy, `
    Invoke-MkAliasSave, `
    Invoke-MkAliasDeleteTemplate, `
    Invoke-MkAliasClearTemplates, `
    Invoke-MkAliasListTemplates, `
    Invoke-MkAliasDoctor, `
    Invoke-MkAliasHelp, `
    Invoke-MkAliasAlias, `
    Show-MkBoxHelp, `
    New-MkBoxFolder, `
    New-MkBoxFile, `
    Remove-MkBoxItem, `
    Copy-MkBoxItem, `
    Save-MkBoxUserTemplate, `
    Remove-MkBoxUserTemplate, `
    Clear-MkBoxUserTemplates, `
    Get-MkBoxTemplatesTree, `
    Invoke-MkBoxDoctor, `
    Show-MkBoxAliases, `
    mkbox

Export-ModuleMember -Alias mkinit, mkroot, mkgetproject, mkgetfile, mkfolder, mkfile, mkrm, mkcopy, mksave, mkdel, mkclr, mkls, mkdoc, mkhelp, mkalias
