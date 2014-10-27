function _workOnConsoleWorkingDirectory {
	param(
		[Parameter(Mandatory=$true, Position = 0)][scriptblock]$ScriptBlock,
        [switch]$ReturnValue
    )

	$workingDirectory = $ProfileConfig.Module.InstallPath.TrimEnd("\")
	if (-not (Test-Path $workingDirectory)) {
		throw "Unable to locate Console Install Path ($workingDirectory), this is a fatal error and may require reinstallation"
	}
    $currentDirectory = $PWD.Path.TrimEnd("\")
    if ($currentDirectory -ne $workingDirectory) {
        Push-Location $workingDirectory
    }
    try {
    	$gitDirectory = & git rev-parse --git-dir
    	if (-not (Test-Path $gitDirectory)) {
    		throw "Install Path ($workingDirectory) is not a Git repository, this is a fatal error and may require reinstallation"
    	}

    	$ScriptBlock.Invoke() | ? { $ReturnValue } | Write-Output
    }
    catch {
        Write-Host -ForegroundColor Red "ERROR: $($_.Exception.InnerException.Message)"
        throw "Unable to continue Git command"
    }
	finally {
        if ($currentDirectory -ne $workingDirectory) {
		  Pop-Location
        }
	}
}