[CmdletBinding()]
param (
    [string]$rootPath = $PWD.Path
)

# Script metadata and documentation
<#
.SYNOPSIS
    Interactive directory navigation menu
.DESCRIPTION
    Provides a CLI menu for navigating directory structures
#>

# Initialize logging
$ErrorActionPreference = 'Stop'
$LogPath = Join-Path $PSScriptRoot 'navigation.log'

function Write-Log {
    param($Message)
    "[$(Get-Date)] $Message" | Add-Content -Path $LogPath
}

# Validate root path
if (-not (Test-Path $rootPath)) {
    Write-Warning "Root path not found. Defaulting to current directory."
    $rootPath = $PWD.Path
    Write-Log "Invalid root path, defaulted to: $rootPath"
}

# Initialize variables
$currentPath = $rootPath
$script:dirCache = @{}

Import-Module .\Modules\PS-DirNavigator.psm1 -Force

# Main loop
while ($true) {
    Clear-Host
    
    # Show breadcrumb trail
    $relativePath = $currentPath.Replace($rootPath, "ROOT")
    Write-Host "Location: $relativePath" -ForegroundColor Cyan
    
    if (-not (Test-Path $currentPath)) {
        $currentPath = $rootPath
        Write-Log "Invalid path detected, reset to root"
    }

    $Options = Get-Directories -Path $currentPath
    if (-not $Options) { $Options = @() }

    # Add navigation options
    if ($currentPath -ne $rootPath) {
        $Options = @(".. (Go Up)") + $Options
    }
    $Options += "Exit"

    $selectedOptionIndex = Show-Menu -Title "--[ Directory Navigator: $($relativePath) ]--" -Options $Options

    if ($selectedOptionIndex -eq -1 -or $Options[$selectedOptionIndex] -eq "Exit") {
        Write-Log "User exited navigation"
        break
    }
    elseif ($Options[$selectedOptionIndex] -eq ".. (Go Up)") {
        $currentPath = (Get-Item $currentPath).Parent.FullName
        Write-Log "Navigated up to: $currentPath"
    }
    elseif ($selectedOptionIndex -ge 0 -and $selectedOptionIndex -lt $Options.Count) {
        $newPath = Join-Path -Path $currentPath -ChildPath $Options[$selectedOptionIndex]
        if (Test-Path $newPath) {
            $currentPath = $newPath
            Write-Log "Navigated to: $currentPath"
        }
    }
}

Write-Host "Thank you for using Directory Navigator!" -ForegroundColor Green