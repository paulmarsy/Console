Write-InstallMessage -EnterNewScope "Configuring Console"

$conEmuCommandIcon = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Resources\CommandPrompt.ico"
$conEmuPowerShellIcon = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Resources\PowerShellPrompt.ico"

Get-ChildItem ".\Console" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }

Exit-Scope