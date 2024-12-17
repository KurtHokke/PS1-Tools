##################### Main Menu #####################

Function Show-Menu {
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions
    )

    $MaxValue = $MenuOptions.Count - 1
    $Selection = 0
    $EnterPressed = $False

    Clear-Host

    While (-not $EnterPressed) {
        Write-Host "$MenuTitle"

        For ($i = 0; $i -le $MaxValue; $i++) {
            If ($i -eq $Selection) {
                Write-Host -BackgroundColor Cyan -ForegroundColor Black "> $($MenuOptions[$i])\ "
            } Else {
                Write-Host " $($MenuOptions[$i]) "
            }
        }

        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch ($KeyInput) {
            13 { # Enter key
                $EnterPressed = $True
                Return $Selection# Break the loop
            }
            37 { # Left arrow
                Return -1 # Indicate to go up a directory
            }
            39 { # Right arrow
                Return $Selection # Indicate to go into the selected directory
            }
            38 { # Up arrow
                If ($Selection -eq 0) {
                    $Selection = $MaxValue
                } Else {
                    $Selection -= 1
                }
            }
            40 { # Down arrow
                If ($Selection -eq $MaxValue) {
                    $Selection = 0
                } Else {
                    $Selection += 1
                }
            }
            Default { }
        }

        Clear-Host
    }
}

Function Get-Directories {
    Param(
        [String]$Path
    )
    # Get directories in the specified path
    Get-ChildItem -Path $Path -Directory | Select-Object -ExpandProperty Name
}

# Store both current path and root path
$currentPath = (Get-Location).Path
$rootPath = [System.IO.Path]::GetPathRoot($currentPath)
#$initialPath = $currentPath # Store the initial path

While ($true) {
    # Ensure current path is valid, fallback to root if not
    if (-not (Test-Path $currentPath)) {
        $currentPath = $rootPath
    }

    # Get the list of directories
    $menuOptions = Get-Directories -Path $currentPath

    # Ensure $menuOptions is not null
    if (-not $menuOptions) {
        $menuOptions = @()
    }

    # Add an option to go up a directory if not at root
    if ($currentPath -ne $rootPath) {
        $menuOptions += ".. (Go Up)"
    }

    # Call the Show-Menu function
    $selectedOptionIndex = Show-Menu -MenuTitle "--[ Main Menu: $currentPath ]--" -MenuOptions $menuOptions

    # Handle the selected option
    if ($selectedOptionIndex -eq -1 -or $menuOptions[$selectedOptionIndex] -eq ".. (Go Up)") {
        # Go up a directory
        $currentPath = (Get-Item $currentPath).Parent.FullName
    } elseif ($selectedOptionIndex -ge 0 -and $selectedOptionIndex -lt $menuOptions.Count) {
        # Change directory into the selected option
        $currentPath = Join-Path -Path $currentPath -ChildPath $menuOptions[$selectedOptionIndex]
    }
}

Read-Host -Prompt "Press Enter to exit"
Export-ModuleMember -Function 'Show-Menu'