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
	}

    $gitProcess = Start-Process @arguments

    if ($Quiet -and (Test-Path $standardOutput)) {
    	Remove-Item $standardOutput -Force
    }
    
    if ($gitProcess.ExitCode -ne 0) {
    	if ($NonFatalError) { return $gitProcess.ExitCode }
    	else { throw "Git command ($Command) returned exit code: $($gitProcess.ExitCode)" }
    }
}