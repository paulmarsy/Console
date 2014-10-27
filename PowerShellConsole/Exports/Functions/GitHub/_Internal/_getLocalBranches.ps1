function _getLocalBranches {
    [array](_workOnConsoleWorkingDirectory {
        [array]$localBranchNames = & git branch -l | % Remove 0 2
        if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
        return $localBranchNames
	} -ReturnValue)
}