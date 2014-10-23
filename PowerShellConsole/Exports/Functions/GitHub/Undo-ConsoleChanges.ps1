function Undo-ConsoleChanges {
	_workOnConsoleWorkingDirectory {
		if ((_getNumberOfUncommitedChanges) -eq 0) {
			Write-Host -ForegroundColor Red "ERROR: There are no changes to undo"
			return
		}
		Write-Host -ForegroundColor Cyan "Discarding local Console Git changes..." 
		_invokeGitCommand "clean -df"
		_invokeGitCommand "checkout ."
    }
}