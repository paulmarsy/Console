function Merge-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ParentBranchName = "master",
		[Parameter(Mandatory=$true,Position=0)][ValidateSet("master")]$ChildBranchName
    )

	_enterConsoleWorkingDirectory {
	}
}