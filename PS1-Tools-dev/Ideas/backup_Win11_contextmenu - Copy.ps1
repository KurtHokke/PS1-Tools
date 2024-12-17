
########################## PS1 Script ##########################


$currentDirectory = Get-Location

# Use the correct registry path format
$registryKeyPath = "HKCU\Software\Classes\CLSID"
$outputBackupFilePath = Join-Path -Path $env:USERPROFILE -ChildPath "HKEY_CURRENT_USER--Software--Classes--CLSID.bak.reg"

$keyExists = Test-Path $registryKeyPath

if ($keyExists) {
    try {
        reg export $registryKeyPath $outputBackupFilePath /y
        Write-Host "Registry key backed up successfully to $outputBackupFilePath"
    } catch {
        Write-Host "Failed to back up registry key: $_"
    }
	
	
    # Define the InprocServer32 path
    $inprocServer32Path = "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

    # Check if the InprocServer32 entry exists
    $inprocServer32Value = Get-ItemProperty -Path $inprocServer32Path -Name "(default)" -ErrorAction SilentlyContinue

    if ($inprocServer32Value) {
        Write-Host "[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]"
        Write-Host "@="""
    } else {
        Write-Host "The InprocServer32 entry does not exist."
    }

    # Ask the user if they want to import the registry entry
    $importResponse = Read-Host -Prompt "Do you want to import this entry back to the registry? (Y/N)"
    if ($importResponse -eq 'Y' -or $importResponse -eq 'y') {



###################################### CREATING WIN11 CONTEXTMENU ######################################
		$RegUnPatchFilePath = Join-Path -Path $currentDirectory -ChildPath "Win11_ContextMenu_Patch.reg"
        @"
Windows Registry Editor Version 5.00

[-HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]
"@ | Set-Content -Path $RegUnPatchFilePath
###################################### CREATING WIN11 CONTEXTMENU ######################################

###################################### CREATING WIN10 CONTEXTMENU ######################################
		$RegPatchFilePath = Join-Path -Path $currentDirectory -ChildPath "Win10_ContextMenu_Patch(ALREADY_APPLIED).reg"
        @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]
@=""
"@ | Set-Content -Path $RegPatchFilePath
###################################### CREATING WIN10 CONTEXTMENU ######################################



        reg import $RegPatchFilePath
        Write-Host "Registry entry imported successfully."
        
    } else {
        Write-Host "Import operation canceled."
    }
} else {
    Write-Host "The specified registry key does not exist: $registryKeyPath"
}

Read-Host -Prompt "Press Enter to exit"