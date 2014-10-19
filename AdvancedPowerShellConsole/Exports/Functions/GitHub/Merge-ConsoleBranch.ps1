function Merge-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true, Position=0)][ValidateSet("master")]$SourceBranchName,
		[Parameter(Mandatory=$true, Position=1)][ValidateSet("master")]$DestinationBranchName
    )

	_workOnConsoleWorkingDirectory {
		if ((Assert-ConsoleIsInSync -Quiet -AssertIsFatal) -eq $false) { return }

		$currentBranch = _getCurrentBranch
		if ($currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $DestinationBranchName -Quiet
		}

		Write-Host -ForegroundColor Cyan "Merging branch $SourceBranchName into $DestinationBranchName..."
		_invokeGitCommand "merge --verbose $SourceBranchName"

		if ($currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $currentBranch -Quiet
		}
	}
}