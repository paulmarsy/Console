function _invokeGitCommand {
	param(
		$Command,
		[switch]$Quiet
	)

	$arguments = @{
		"FilePath" = "git.exe"
		"ArgumentList" = $Command
		"WorkingDirectory" = $ProfileConfig.General.InstallPath
		"Wait" = $true
		"PassThru" = $true
	}
	if ($Quiet) { $arguments += @{"WindowStyle" = "Hidden"} }
	else { $arguments += @{"NoNewWindow" = $true } }
    $gitProcess = Start-Process @arguments
    if ($gitProcess.ExitCode -ne 0) {
    	throw "Git command returned exit code: $LASTEXITCODE"
    }
}