function Compare-ConsoleBranches {
	param(
		[Parameter(Mandatory=$true, Position=0)][ValidateSet("master")]$LeftBranchName,
		[Parameter(Mandatory=$true, Position=1)][ValidateSet("master")]$RightBranchName
    )

	_workOnConsoleWorkingDirectory {
		_invokeGitCommand "diff $LeftBranchName..$RightBranchName"
	}
}