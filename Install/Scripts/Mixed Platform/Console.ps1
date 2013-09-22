Write-InstallMessage -EnterNewScope "Configuring Console"

$conEmuExecutable = Join-Path $InstallPath "Console\ConEmu64.exe"
$conEmuIcon = Join-Path $InstallPath "Support Files\Icons\PowerShellPrompt.ico"

Get-ChildItem ".\Console" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }

Exit-Scope