function _invokeGitCommand {
	param(
		$Command,
		[switch]$Quiet,
		[switch]$NonFatalError
	)

	$arguments = @{
		"FilePath" = "git.exe"
		"ArgumentList" = $Command
		"WorkingDirectory" = $PWD.Path
		"Wait" = $true
		"PassThru" = $true
		"NoNewWindow" = $true
	}
	if ($Quiet) {
		$standardOutput = [System.IO.Path]::GetTempFileName()
		$arguments += @{ "RedirectStandardOutput" = $standardOutput }
		$standardError = [System.IO.Path]::GetTempFileName()
		$arguments += @{ "RedirectStandardError" = $standardError }

		$cleanup = {
			if (Test-Path $standardOutput) { Remove-Item $standardOutput -Force }
			if (Test-Path $standardError) { Remove-Item $standardError -Force }
		}		
	} else {
		$cleanup = {}
	}

    $gitProcess = Start-Process @arguments
    
    if ($gitProcess.ExitCode -ne 0 -and $null -ne $gitProcess.ExitCode) {
    	if ($NonFatalError) {
    		& $cleanup
    		return $gitProcess.ExitCode
    	}
    	else {
    		$errorMessage = "Git command ($Command) returned exit code: $($gitProcess.ExitCode)"
    		if ($Quiet) {
    			$errorMessage += "`nCommand Output: $(Get-Content $standardOutput)"
    			$errorMessage += "`nError Message: $(Get-Content $standardError)"
    		}
    		& $cleanup
    		throw $errorMessage
    	}
    } else {
		& $cleanup
    }
}