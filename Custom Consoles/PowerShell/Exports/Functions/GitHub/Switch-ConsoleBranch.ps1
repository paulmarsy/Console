function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 0)][switch]$CreateNewBranch,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 1)]$NewBranchName,
		[Parameter(ParameterSetName="NewBranch", Position = 2)][ValidateSet("master")]$ParentBranchName = "master",
		[switch]$Quiet
    )

	_workOnConsoleWorkingDirectory {
		if ($CreateNewBranch) {
			if (-not (Test-NetworkStatus)) {
				throw "Unable to continue without network connectivity"
			}

			_invokeGitCommand "checkout $ParentBranchName"

			Write-Host -ForegroundColor Cyan "Creating remote branch $NewBranchName on GitHub..."
			_invokeGitCommand "push origin origin:refs/heads/$NewBranchName"
			_invokeGitCommand "fetch origin $NewBranchName"
			
			Write-Host -ForegroundColor Cyan "Creating local branch $NewBranchName..."
			_invokeGitCommand "branch $NewBranchName origin/$NewBranchName"
			
			$BranchName = $NewBranchName
		}

		if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch.IsPresent } { "new " })branch $BranchName..." }
		[array]$previousBranchSubmodules = _getSubmodulePaths
		_invokeGitCommand "checkout $BranchName" -Quiet
		_invokeGitCommand "submodule update --init --force --recursive" -Quiet
		[array]$newBranchSubmodules = _getSubmodulePaths
		Compare-Object -ReferenceObject $previousBranchSubmodules -DifferenceObject $newBranchSubmodules | ? SideIndicator -eq "<=" | % InputObject | % {
			Remove-Item -Path $_ -Recurse -Force
		}
    }
}