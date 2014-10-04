function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Position = 0)]$NewBranchName,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true)][switch]$CreateNewBranch,
		[Parameter(ParameterSetName="NewBranch")][switch]$Force
    )

	_enterConsoleWorkingDirectory {
		param($BranchName, $NewBranchName, $Force, $PsCmdlet)
	
		_checkBranchForUncommitedFiles

		if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
			Write-Host -ForegroundColor Cyan "Creating new branch $NewBranchName..."
			& git branch $NewBranchName (?: { $Force.IsPresent } { "--force" })
			
			Write-Host -ForegroundColor Cyan "Publishing branch to GitHub..."
			& git push -u origin $NewBranchName
			#Sync-Console

			$BranchName = $NewBranchName
		}

		Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch.IsPresent } { "new " })branch $BranchName..."
		& git checkout $BranchName
    } @($BranchName, $NewBranchName, $Force, $PsCmdlet) | Out-Null
}