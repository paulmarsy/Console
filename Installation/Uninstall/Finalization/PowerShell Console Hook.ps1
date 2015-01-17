Write-InstallMessage -EnterNewScope "Removing PowerShell Console Hook"

$PowerShellConsoleHookToken = "<# PowerShellConsole Hook #>"

Invoke-InstallStep "Removing hook from PowerShell Profile" {
	if (Test-Path $PowerShellConsoleConstants.HookFiles.PowerShell) {
		$token = Get-Content $PowerShellConsoleConstants.HookFiles.PowerShell | Select-Object -First 1
	 	if ($token -eq $PowerShellConsoleHookToken) {
	    	Remove-Item $PowerShellConsoleConstants.HookFiles.PowerShell -Force
		} else {
			Write-InstallMessage -Type Warning "Existing $($PowerShellConsoleConstants.HookFiles.PowerShell) file isn't hooked up"
		}
	}
}

Exit-Scope