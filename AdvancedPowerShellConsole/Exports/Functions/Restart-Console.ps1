function Restart-Console {
	[CmdletBinding()]
	param(
		[Parameter(Position = 0)]$Message = "Advanced PowerShell Console has been restarted"
	)

	$command = "& { Write-Host -ForegroundColor Red '$Message' }"
	$encodedCommand = [Convert]::ToBase64String(([System.Text.Encoding]::Unicode.GetBytes($command)))

    Start-Process -FilePath "$InstallPath\Third Party\Console\ConEmu64.exe" -ArgumentList "/cmd powershell.exe -NoExit -EncodedCommand $encodedCommand" -WorkingDirectory $pwd
    Exit
}