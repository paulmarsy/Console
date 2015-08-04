function Save-LocalPowerShellConsoleChanges {
	[CmdletBinding()]
	param(
		[Parameter(ParameterSetName="Major", Mandatory=$true)][switch]$Major,
        [Parameter(ParameterSetName="Minor", Mandatory=$true)][switch]$Minor,
        [Parameter(ParameterSetName="Patch", Mandatory=$true)][switch]$Patch,
		[Parameter(ParameterSetName="None", Mandatory=$false)][switch]$NoVersionChange,
		
		[Parameter(ValueFromRemainingArguments=$true)][ValidateNotNullOrEmpty()][string]$CommitMessage
    )

	Optimize-PowerShellConsoleFiles

	$script:changesCommited = $false
	filter commitChanges {
		try {
			Push-Location $_
			
			if ((& git status --porcelain 2>$null | Measure-Object -Line | Select-Object -ExpandProperty Lines) -eq 0) { return }
			if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }

			Write-Host -ForegroundColor Cyan "Commiting changes to $(Split-Path $_ -Leaf)..."
			_invokeGitCommand "add -A" | Out-Null
			_invokeGitCommand "commit -a -m `"$CommitMessage`""
			$script:changesCommited = $true
		}
		finally {
			Pop-Location
		}
	}

	_workOnConsoleWorkingDirectory {
		$output = & git submodule foreach --quiet 'echo $path' | % Replace "/" "\" | commitChanges
		if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
		return $output
	} 

	if ($PsCmdlet.ParameterSetName -eq "Major") { Update-PowerShellConsoleVersion -Major -Quiet }
	if ($PsCmdlet.ParameterSetName -eq "Minor") { Update-PowerShellConsoleVersion -Minor -Quiet }
	if ($PsCmdlet.ParameterSetName -eq "Patch") { Update-PowerShellConsoleVersion -Patch -Quiet }

	$ProfileConfig.Module.InstallPath | commitChanges "Main Console Repo..."

	if ($script:changesCommited) {
		Write-Host -ForegroundColor Green "Changes commited successfully!"
	} else {
		Write-Host -ForegroundColor Red "No changes commited"
	}
}
