function _getSubmodulePaths {
	[array](_workOnConsoleWorkingDirectory {
	    $output = & git submodule foreach --quiet 'echo $path'
	    if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
	    return $output
    } -ReturnValue)
}