function Publish-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$ParentBranchName = "master"
    )
    
    if (-not (Test-NetworkStatus)) {
		Write-Host -ForegroundColor Red "ERROR: Unable to continue without network connectivity"
		return
    }

	_workOnConsoleWorkingDirectory {
		if (-not (Assert-ConsoleIsInSync)) {
			Write-Host -ForegroundColor Red "Unable to publish branch while there are uncommited changes, use Save-ConsoleChanges or Undo-ConsoleChanges to stabilise the workspace before retrying" 
			return
		}

		Sync-ConsoleWithGitHub

		Merge-ConsoleBranch -SourceBranchName "origin/$ParentBranchName" -DestinationBranchName $ParentBranchName -DontSyncWithGitHub
		Merge-ConsoleBranch -SourceBranchName $ParentBranchName -DestinationBranchName $ChildBranchName -DontSyncWithGitHub
		Merge-ConsoleBranch -SourceBranchName "origin/$ChildBranchName" -DestinationBranchName $ChildBranchName -DontSyncWithGitHub
		Merge-ConsoleBranch -SourceBranchName $ChildBranchName -DestinationBranchName "origin/$ChildBranchName" -DontSyncWithGitHub
		Merge-ConsoleBranch -SourceBranchName $ChildBranchName -DestinationBranchName $ParentBranchName -DontSyncWithGitHub
		Merge-ConsoleBranch -SourceBranchName $ParentBranchName -DestinationBranchName "origin/$ParentBranchName" -DontSyncWithGitHub
		
		Switch-ConsoleBranch -BranchName $ChildBranchName; Sync-ConsoleWithGitHub
		Switch-ConsoleBranch -BranchName $ParentBranchName; Sync-ConsoleWithGitHub

		Write-Host -ForegroundColor Cyan "Deleting branch $ChildBranchName..."
		_invokeGitCommand "branch -d $ChildBranchName"
		_invokeGitCommand "push origin --delete $ChildBranchName"

		Sync-ConsoleWithGitHub
	}
}