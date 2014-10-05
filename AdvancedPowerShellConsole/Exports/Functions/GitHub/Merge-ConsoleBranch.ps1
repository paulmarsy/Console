function Merge-ConsoleBranch {
	param(
		[Parameter(Mandatory=$true, Position=0)][ValidateSet("master")]$SourceBranchName,
		[Parameter(Position=1)][ValidateSet("master")]$DestinationBranchName,
		[switch]$DontSyncWithGitHub
    )

	_enterConsoleWorkingDirectory {
		param($SourceBranchName, $DestinationBranchName)

		$currentBranch = _getCurrentBranch
		if ($null -ne $DestinationBranchName -or $currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $DestinationBranchName
		}

		Write-Host -ForegroundColor Cyan "Merging branch $SourceBranchName into $DestinationBranchName..."
		& git merge --verbose $SourceBranchName | Write-Host

		if (-not $DontSyncWithGitHub) {
			Sync-ConsoleWithGitHub
		}

		if ($currentBranch -ne $DestinationBranchName) {
			Switch-ConsoleBranch -BranchName $currentBranch
		}
	} @($SourceBranchName, $DestinationBranchName) | Write-Host
}