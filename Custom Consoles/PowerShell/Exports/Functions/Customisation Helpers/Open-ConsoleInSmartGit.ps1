function Open-ConsoleInSmartGit {
	[CmdletBinding(DefaultParameterSetName="Open")]
	param(
		[Parameter(ParameterSetName="Open")][switch]$Open,
		[Parameter(ParameterSetName="Log")][switch]$Log,
		[Parameter(ParameterSetName="Blame")][switch]$Blame
	)

	$smartGitExe = Join-Path  ${Env:ProgramFiles(x86)} "SmartGit\bin\smartgit.exe"

	if (-not (Test-Path $smartGitExe)) {
		throw "SmartGit does not appear to be installed (could not find $smartGitExe)"
	}

	$mode = switch ($PsCmdlet.ParameterSetName) {
				"Open" { "--open" }
				"Log" { "--log" }
				"Blame" { "--blame" }
			}

	Start-Process	-FilePath $smartGitExe `
					-ArgumentList @("--cwd `"$($ProfileConfig.Module.InstallPath)`"", $mode)
}
