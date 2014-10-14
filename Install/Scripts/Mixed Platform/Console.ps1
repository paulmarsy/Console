Write-InstallMessage -EnterNewScope "Configuring Console"

$conEmuCommandIcon = Join-Path $InstallPath "Support Files\Icons\CommandPrompt.ico"
$conEmuPowerShellIcon = Join-Path $InstallPath "Support Files\Icons\PowerShellPrompt.ico"

Get-ChildItem ".\Console" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }

Exit-Scope