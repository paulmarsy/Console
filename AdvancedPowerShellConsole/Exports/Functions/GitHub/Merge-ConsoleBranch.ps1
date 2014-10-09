function Merge-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true, Position=0)][ValidateSet("master")]$SourceBranchName,
		[Parameter(Mandatory=$true, Position=1)][ValidateSet("master")]$DestinationBranchName,
		[switch]$DontSyncWithGitHub
    )

	_workOnConsoleWorkingDirectory {
		param($SourceBranchName, $DestinationBranchName)

		if ((Assert-ConsoleIsInSync -Quiet -AssertIsFatal) -eq $false) { return }

		$currentBranch = _getCurrentBranch
		if ($currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $DestinationBranchName
		}

		Write-Host -ForegroundColor Cyan "Merging branch $SourceBranchName into $DestinationBranchName..."
		_invokeGitCommand "merge --verbose origin/$SourceBranchName"
		_invokeGitCommand "merge --verbose $SourceBranchName"

		if (-not $DontSyncWithGitHub) {
			Sync-ConsoleWithGitHub
		}

		if ($currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $currentBranch
		}
	} @($SourceBranchName, $DestinationBranchName)
}