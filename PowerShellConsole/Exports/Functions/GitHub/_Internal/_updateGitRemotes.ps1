function _updateGitRemotes {
    param(
        [switch]$Quiet,
        [switch]$UpdateSubModules
    )
    _workOnConsoleWorkingDirectory {
        _invokeGitCommand "remote --verbose update --prune" -Quiet:$Quiet 
        _invokeGitCommand "submodule update --init --recursive $(?:{ $UpdateSubModules } { "--remote --rebase" })" -Quiet:$Quiet
	}
}