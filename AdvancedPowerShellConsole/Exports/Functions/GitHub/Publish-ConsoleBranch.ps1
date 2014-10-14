function Publish-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$ParentBranchName = "master"
    )

	_workOnConsoleWorkingDirectory {
		if ((Assert-ConsoleIsInSync -Quiet -AssertIsFatal) -eq $false) { return }

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