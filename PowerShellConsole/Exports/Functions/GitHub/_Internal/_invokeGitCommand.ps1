function _invokeGitCommand {
	param(
		$Command,
		[switch]$Quiet,
		[switch]$NonFatalError
	)

	$arguments = @{
		"FilePath" = "git.exe"
		"ArgumentList" = $Command
		"WorkingDirectory" = $ProfileConfig.Module.InstallPath
		"Wait" = $true
		"PassThru" = $true
		"NoNewWindow" = $true
	}
	if ($Quiet) {
		$standardOutput = [System.IO.Path]::GetTempFileName()
		$arguments += @{ "RedirectStandardOutput" = $standardOutput }
		$standardError = [System.IO.Path]::GetTempFileName()
		$arguments += @{ "RedirectStandardError" = $standardError }
		
	}

    $gitProcess = Start-Process @arguments

    if ($Quiet -and (Test-Path $standardOutput)) {
    	Remove-Item $standardOutput -Force
    }
    
    if ($gitProcess.ExitCode -ne 0 -and $null -ne $gitProcess.ExitCode) {
    	if ($NonFatalError) { return $gitProcess.ExitCode }
    	else {
    		$errorMessage = "Git command ($Command) returned exit code: $($gitProcess.ExitCode)"
    		if ($Quiet) {
    			$errorMessage += "`nCommand Output: $(Get-Content $standardOutput)"
    			$errorMessage += "`nError Message: $(Get-Content $standardError)"
    		}
    		throw $errorMessage
    	}
    }
}