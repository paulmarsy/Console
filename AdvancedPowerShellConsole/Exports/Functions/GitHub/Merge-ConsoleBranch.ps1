function Merge-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$ParentBranchName = "master"
    )

	_enterConsoleWorkingDirectory {
		param($ChildBranchName, $ParentBranchName)

		Switch-ConsoleBranch -BranchName $ParentBranchName

		& git merge $ChildBranchName

		& git branch -d $ChildBranchName

		Sync-Console

	} @($ChildBranchName, $ParentBranchName)
}