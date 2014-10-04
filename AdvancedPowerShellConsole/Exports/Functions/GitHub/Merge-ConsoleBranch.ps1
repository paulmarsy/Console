function Merge-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$ParentBranchName = "master"
    )

	_enterConsoleWorkingDirectory {
		param($ChildBranchName, $ParentBranchName)

		Switch-ConsoleBranch -BranchName $ParentBranchName

		Write-Host -ForegroundColor Cyan "Merging branch $ChildBranchName into $ParentBranchName..."
		& git merge $ChildBranchName | Write-Host

		Write-Host -ForegroundColor Cyan "Deleting branch $ChildBranchName..."
		& git branch -d $ChildBranchName | Write-Host
		& git push origin :$ChildBranchName | Write-Host

		Sync-Console

	} @($ChildBranchName, $ParentBranchName)
}