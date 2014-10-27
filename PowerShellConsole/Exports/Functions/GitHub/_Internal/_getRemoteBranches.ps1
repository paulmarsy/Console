function _getRemoteBranches {
    _workOnConsoleWorkingDirectory {
        $remoteBranchNames =  @() + (& git branch -r | % Remove 0 2 | ? { -not $_.StartsWith("origin/HEAD") })
        if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
        return $remoteBranchNames
	} -ReturnValue
}