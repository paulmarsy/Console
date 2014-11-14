function _updateGitRemotes {
    param(
        [switch]$Quiet
    )
    _workOnConsoleWorkingDirectory {
    	$updateCommand = "remote --verbose update --prune"
        _invokeGitCommand $updateCommand -Quiet:$Quiet
        _invokeGitCommand "submodule foreach --recursive git $updateCommand" -Quiet:$Quiet
        _updateGitHubCmdletParameters
	}
}