function Push-Temp {
    if ($PWD.Path -ne $ProfileConfig.General.TempFolder) {
        Push-Location -Path $ProfileConfig.General.TempFolder -StackName "PowerShellConsoleTempFolder"
    }
}