function Invoke-MkBoxNew {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet("file", "folder")]
        [string]$Instance,
        [Parameter(Position = 1, ValueFromRemainingArguments = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("n")]
        [string[]]$Name
    )

    if ([string]::IsNullOrWhiteSpace($Instance)) {
        Write-MkBoxHost -m "Please specify instance: file or folder." -t "wr"
        return
    }

    if ($null -eq $Name -or $Name.Count -eq 0) {
        Write-MkBoxHost -m "Please provide one or more names to create." -t "wr"
        return
    }

    switch ($Instance) {
        "file" { New-MkBoxFile -FileName $Name; return }
        "folder" { New-MkBoxFolder -FolderName $Name; return }
        Default {
            Write-MkBoxHost -m "Unsupported instance: $Instance" -t "wr"
            return
        }
    }
}
