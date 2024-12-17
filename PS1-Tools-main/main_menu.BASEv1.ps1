
##################### Main Menu #####################

Function Create-Menu {
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
                Return $Selection
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

# Define the menu title and options
$menuTitle = "--[Main Menu]--"
$menuOptions = @("Option 1", "Option 2", "Option 3", "Exit")

# Call the Create-Menu function
$selectedOptionIndex = Create-Menu -MenuTitle $menuTitle -MenuOptions $menuOptions

# Handle the selected option
switch ($selectedOptionIndex) {
    0 { Write-Host "You selected Option 1" }
    1 { Write-Host "You selected Option 2" }
    2 { Write-Host "You selected Option 3" }
    3 { Write-Host "Exiting..." }
}

Read-Host -Prompt "Press Enter to exit"