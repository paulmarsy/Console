function Remove-ConsoleBranch {
	param(
		[Parameter(Mandatory = $true)][ValidateSet("master")]$BranchName = "master",
		[switch]$Force
    )

    if ($BranchName -eq "master") {
    	Write-Host -ForegroundColor Red "ERROR: You can't delete the master branch!"
    	return
    }

	# _workOnConsoleWorkingDirectory {
	# 	param($BranchName, $Force)
	
	# 	_invokeGitCommand "branch -D $ChildBranchName"

	# 	Sync-ConsoleWithGitHub
		
	# 	if ((Assert-ConsoleIsInSync -Quiet -AssertIsFatal) -eq $false) { return }

	# 	if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
	# 		_invokeGitCommand "checkout $ParentBranchName"

	# 		Write-Host -ForegroundColor Cyan "Creating remote branch $NewBranchName on GitHub..."
	# 		_invokeGitCommand "push origin origin:refs/heads/$NewBranchName"
	# 		_invokeGitCommand "remote --verbose update --prune" -Quiet
			
	# 		Write-Host -ForegroundColor Cyan "Creating local branch $NewBranchName..."
	# 		_invokeGitCommand "branch --set-upstream-to=origin/$NewBranchName $NewBranchName"

	# 		Sync-ConsoleWithGitHub
	# 		$BranchName = $NewBranchName
	# 	}

	# 	Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch.IsPresent } { "new " })branch $BranchName..."
	# 	_invokeGitCommand "checkout $BranchName"
 #    } @($BranchName, $Force)
}