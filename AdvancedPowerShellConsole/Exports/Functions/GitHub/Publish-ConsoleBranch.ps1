function Publish-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$ParentBranchName = "master"
    )

	_workOnConsoleWorkingDirectory {
		param($ChildBranchName, $ParentBranchName)

		if ((Assert-ConsoleIsInSync -Quiet -AssertIsFatal) -eq $false) { return }

		Merge-ConsoleBranch -SourceBranchName $ChildBranchName -DestinationBranchName $ParentBranchName

		Switch-ConsoleBranch -BranchName $ParentBranchName

		Write-Host -ForegroundColor Cyan "Deleting branch $ChildBranchName..."
		_invokeGitCommand "branch -d $ChildBranchName"
		_invokeGitCommand "push origin --delete $ChildBranchName"

		Sync-ConsoleWithGitHub
	} @($ChildBranchName, $ParentBranchName)
}