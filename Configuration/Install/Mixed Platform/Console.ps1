Write-InstallMessage -EnterNewScope "Configuring Console"

$conEmuCommandIcon = Join-Path $PowerShellConsoleContstants.InstallPath "Libraries\Icons\CommandPrompt.ico"
$conEmuPowerShellIcon = Join-Path $PowerShellConsoleContstants.InstallPath "Libraries\Icons\PowerShellPrompt.ico"

Get-ChildItem ".\Console" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }

Exit-Scope