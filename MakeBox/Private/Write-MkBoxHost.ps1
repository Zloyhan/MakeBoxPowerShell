function Write-MkBoxHost {
    [CmdletBinding()]
    param (
        [Alias("m")]
        [parameter(Mandatory = $true)]
        [string]$Message,
        [ValidateSet("dn", "wr", "err", "i", "?")]
        [Alias("t")]
        [string]$Type
    )
    
    switch ($Type) {
        "dn" { 
            Write-Host "✓ " -ForegroundColor Green -NoNewline
            Write-Host "$($PSStyle.Foreground.FromRgb(255, 165, 0))mkbox: $($PSStyle.Reset)" -noNewline
            Write-Host $Message -ForegroundColor Green
        }
        "wr" { 
            Write-Host "⚠ " -ForegroundColor Yellow -NoNewline
            Write-Host "$($PSStyle.Foreground.FromRgb(255, 165, 0))mkbox: $($PSStyle.Reset)" -noNewline
            Write-Host $Message -ForegroundColor Yellow
        }
        "err" { 
            Write-Host "✗ " -ForegroundColor Red -NoNewline
            Write-Host "$($PSStyle.Foreground.FromRgb(255, 165, 0))mkbox: $($PSStyle.Reset)" -noNewline
            Write-Host $Message -ForegroundColor Red
        }
        "i" { 
            Write-Host "i " -ForegroundColor White -NoNewline
            Write-Host "$($PSStyle.Foreground.FromRgb(255, 165, 0))mkbox: $($PSStyle.Reset)" -noNewline
            Write-Host $Message -ForegroundColor White
        }
        "?" {
            Write-Host "? " -ForegroundColor Cyan -NoNewline
            Write-Host "$($PSStyle.Foreground.FromRgb(255, 165, 0))mkbox: $($PSStyle.Reset)" -noNewline
            Write-Host $Message -ForegroundColor Cyan
        }
        Default {
            Write-Host "$($PSStyle.Foreground.FromRgb(255, 165, 0))> $($PSStyle.Reset)" -NoNewline 
            Write-Host "$($PSStyle.Foreground.FromRgb(255, 165, 0))mkbox: $($PSStyle.Reset)" -noNewline
            Write-Host $Message -ForegroundColor White
        }
    }
}
