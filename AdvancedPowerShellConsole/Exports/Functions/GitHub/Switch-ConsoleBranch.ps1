function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Position = 0)]$BranchName,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true)][switch]$CreateNewBranch,
		[Parameter(ParameterSetName="NewBranch")][switch]$Force
    )

	_enterConsoleWorkingDirectory {
		param($BranchName, $Force, $PsCmdlet)
	
		_checkBranchForUncommitedFiles

		if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
			Write-Host -ForegroundColor Cyan "Creating new branch $BranchName..."
			& git branch $BranchName (?: { $Force.IsPresent } { "--force" })
			
			Write-Host -ForegroundColor Cyan "Publishing branch to GitHub..."
			& git push -u origin $BranchName
			Sync-Console
		}

		Write-Host -ForegroundColor Cyan "Switching to $(?: { $Force.IsPresent } { "new " })branch..."
		& git checkout $BranchName
    } @($BranchName, $Force, $PsCmdlet)
}