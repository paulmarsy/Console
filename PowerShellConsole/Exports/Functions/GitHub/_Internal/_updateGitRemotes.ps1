function _updateGitRemotes {
    param(
        [switch]$Quiet
    )
    _workOnConsoleWorkingDirectory {
        _invokeGitCommand "remote --verbose update --prune" -Quiet:$Quiet 
        _invokeGitCommand "submodule update --init --recursive --remote --rebase" -Quiet:$Quiet
	}
}