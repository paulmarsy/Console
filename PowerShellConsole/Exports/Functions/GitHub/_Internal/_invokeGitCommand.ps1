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
	}
	if ($Quiet) { $arguments += @{"WindowStyle" = "Hidden"} }
	else { $arguments += @{"NoNewWindow" = $true } }
    $gitProcess = Start-Process @arguments
    if ($gitProcess.ExitCode -ne 0) {
    	if ($NonFatalError) { return $gitProcess.ExitCode }
    	else { throw "Git command ($Command) returned exit code: $($gitProcess.ExitCode)" }
    }
}