function Initialize-MkBoxWorkspace {
   
    [CmdletBinding()]
    param()

    $Currentdir = (Get-Location).Path

    if (Test-Path -PathType Leaf -Path "$Currentdir\.mkboxroot")
    {
        Write-MkBoxHost -m "This directory is already a MakeBox workspace." -t "err"
        return
    } 

    if (-not (Test-Path -PathType Container -Path"$Currentdir\common")) 
    {
        New-Item -Path "$Currentdir" -ItemType Directory -Name "common" | Out-Null
    }

    if (-not (Ensure-MkBoxUserTemplatesStore -CreateIfMissing))
    {
        Write-MkBoxHost -m "Workspace init stopped. User templates store check failed." -t "err"
        return
    }

    New-Item -Path "$Currentdir" -ItemType File -Name ".mkboxroot" | Out-Null
    Write-MkBoxHost -m "MkBox workspace initialized successfully." -t "dn" 

    return
} 
