function Merge-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true, Position=0)][ValidateSet("master")]$SourceBranchName,
		[Parameter(Mandatory=$true, Position=1)][ValidateSet("master")]$DestinationBranchName,
		[switch]$Quiet
    )

	_workOnConsoleWorkingDirectory {
		if (-not (Assert-ConsoleIsInSync)) { 
			Write-Host -ForegroundColor Red "Unable to merge branches while there are uncommited changes, use Save-ConsoleChanges or Undo-ConsoleChanges to stabilise the workspace before retrying" 
			return
		}

		$currentBranch = _getCurrentBranch
		if ($currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $DestinationBranchName -Quiet:$Quiet
		}

		Write-Host -ForegroundColor Cyan "Merging branch $SourceBranchName into $DestinationBranchName..."
		_invokeGitCommand "merge --verbose $SourceBranchName"

		if ($currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $currentBranch -Quiet:$Quiet
		}
	}
}