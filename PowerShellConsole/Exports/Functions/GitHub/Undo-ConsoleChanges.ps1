function Undo-ConsoleChanges {
	_workOnConsoleWorkingDirectory {
		if ((_getNumberOfUncommitedChanges) -eq 0) {
			throw "There are no changes to undo"
		}
		Write-Host -ForegroundColor Cyan "Discarding local Console Git changes..." 
		_invokeGitCommand "clean -df"
		_invokeGitCommand "checkout ."
    }
}