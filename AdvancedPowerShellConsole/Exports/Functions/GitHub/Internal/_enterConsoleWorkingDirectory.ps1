function _enterConsoleWorkingDirectory {
	param(
		[Parameter(Mandatory=$true, Position = 0)][scriptblock]$ScriptBlock,
        [Parameter(Position = 1)]$ArgumentList = $null
    )

	$workingDirectory = $ProfileConfig.General.InstallPath
	if (-not (Test-Path $workingDirectory)) {
		throw "Unable to locate Console Install Path ($workingDirectory), this is a fatal error and may require reinstallation"
	}
    Push-Location $workingDirectory
    try {
    	$gitDirectory = & git rev-parse --git-dir
    	if (-not (Test-Path $gitDirectory)) {
    		throw "Install Path ($workingDirectory) is not a Git repository, this is a fatal error and may require reinstallation"
    	}
    	
    	return $ScriptBlock.Invoke($ArgumentList)
    }
	finally {
		Pop-Location
	}
}