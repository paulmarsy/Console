function _updateGitRemotes {
    param(
        [switch]$Quiet
    )
    _workOnConsoleWorkingDirectory {
        _invokeGitCommand "remote --verbose update --prune" -Quiet:$Quiet
        _invokeGitCommand "submodule foreach --recursive git remote update --prune" -Quiet:$Quiet
        _updateGitHubCmdletParameters
	}
}