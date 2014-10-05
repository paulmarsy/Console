function Publish-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$ParentBranchName = "master"
    )

	_enterConsoleWorkingDirectory {
		param($ChildBranchName, $ParentBranchName)

		Merge-ConsoleBranch -SourceBranchName $ChildBranchName -DestinationBranchName $ParentBranchName -DontSyncWithGitHub

		Sync-ConsoleWithGitHub

		Write-Host -ForegroundColor Cyan "Deleting branch $ChildBranchName..."
		& git branch -d $ChildBranchName | Write-Host
		& git push origin --delete $ChildBranchName | Write-Host

		Sync-ConsoleWithGitHub
	} @($ChildBranchName, $ParentBranchName) | Write-Host
}