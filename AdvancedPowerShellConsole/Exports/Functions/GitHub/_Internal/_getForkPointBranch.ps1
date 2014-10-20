function _getForkPointBranch {
	param ($BranchName)

    _workOnConsoleWorkingDirectory {
    	$gitCommit = & git merge-base --fork-point $BranchName
    	if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
    	$branchesContainingCommit = & git branch --contains $gitCommit | % Remove @(0, 2)
    	if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }

    	return ($branchesContainingCommit | ? { $_ -ne $BranchName })
	} -ReturnValue
}