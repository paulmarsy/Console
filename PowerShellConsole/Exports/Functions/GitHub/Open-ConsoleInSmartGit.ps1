function Open-ConsoleInSmartGit {
	[CmdletBinding(DefaultParameterSetName="Log")]
	param(
		[Parameter(ParameterSetName="Open")][switch]$Open,
		[Parameter(ParameterSetName="Log")][switch]$Log,
		[Parameter(ParameterSetName="Blame")][switch]$Blame
	)

	$smartGitExe = Join-Path  ${Env:ProgramFiles(x86)} "SmartGitHg\bin\smartgithg.exe"

	if (-not (Test-Path $smartGitExe)) {
		Write-Host -ForegroundColor Red "ERROR: SmartGit does not appear to be installed (could not find $smartGitExe)"
		return
	}

	$mode = switch ($PsCmdlet.ParameterSetName) {
				"Open" { "--open" }
				"Log" { "--log" }
				"Blame" { "--blame" }
			}

	Start-Process	-FilePath $smartGitExe `
					-ArgumentList @("--cwd `"$($ProfileConfig.Module.InstallPath)`"", $mode)
}