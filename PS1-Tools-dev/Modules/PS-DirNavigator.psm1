# Module functions
function Get-Directories {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    try {
        Get-ChildItem -Path $Path -Directory | Select-Object -ExpandProperty Name
    }
    catch {
        Write-Error "Failed to get directories: $_"
        return @()
    }
}

function Show-Menu {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [string[]]$Options
    )
    
    $index = 0
    while ($true) {
        Clear-Host
        Write-Host $Title -ForegroundColor Cyan
        
        0..($Options.Count-1) | ForEach-Object {
            if ($_ -eq $index) {
                Write-Host "> $($Options[$_])" -ForegroundColor Green
            } else {
                Write-Host "  $($Options[$_])"
            }
        }
        
        $key = $Host.UI.RawUI.ReadKey()
        switch ($key.VirtualKeyCode) {
            38 { if ($index -gt 0) { $index-- } }
            40 { if ($index -lt $Options.Count - 1) { $index++ } }
            13 { return $index }
            27 { return -1 }
        }
    }
}

# Export functions
Export-ModuleMember -Function @('Get-Directories', 'Show-Menu')