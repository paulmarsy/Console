Write-InstallMessage -EnterNewScope "Removing PowerShell Console Hook"

$PowerShellConsoleHookToken = "<# PowerShellConsole Hook #>"

Invoke-InstallStep "Removing hook from PowerShell Profile" {
	if (Test-Path $PowerShellConsoleContstants.HookFiles.PowerShell) {
		$token = Get-Content $PowerShellConsoleContstants.HookFiles.PowerShell | Select-Object -First 1
	 	if ($token -eq $PowerShellConsoleHookToken) {
	    	Remove-Item $PowerShellConsoleContstants.HookFiles.PowerShell -Force
		} else {
			Write-InstallMessage -Type Warning "Existing $($PowerShellConsoleContstants.HookFiles.PowerShell) file isn't hooked up"
		}
	}
}

Exit-Scope