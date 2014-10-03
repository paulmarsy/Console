function Publish-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$ParentBranchName = "master"
    )

	_enterConsoleWorkingDirectory {
		param($ChildBranchName, $ParentBranchName)

		Switch-ConsoleBranch -BranchName $ParentBranchName

		& git merge $ChildBranchName
	} @($ChildBranchName, $ParentBranchNam)
}