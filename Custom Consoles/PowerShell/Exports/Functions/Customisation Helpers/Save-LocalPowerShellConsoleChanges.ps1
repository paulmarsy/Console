function Save-LocalPowerShellConsoleChanges {
	[CmdletBinding(DefaultParameterSetName="Patch")]
	param(
		[Parameter(ParameterSetName="Major", Mandatory=$false)][switch]$Major,
        [Parameter(ParameterSetName="Minor", Mandatory=$false)][switch]$Minor,
        [Parameter(ParameterSetName="Patch", Mandatory=$false)][switch]$Patch,
		
		[Parameter(ValueFromRemainingArguments=$true)][ValidateNotNullOrEmpty()][string]$CommitMessage
    )

	Optimize-PowerShellConsoleFiles


	$script:changesCommited = $false
	filter commitChanges {
		try {
			Push-Location $_
			
			if ((_getNumberOfUncommitedChanges) -eq 0) { return }

			Write-Host -ForegroundColor Cyan "Commiting changes to $(Split-Path $_ -Leaf)..."
			_invokeGitCommand "add -A" | Out-Null
			_invokeGitCommand "commit -a -m `"$CommitMessage`""
			$script:changesCommited = $true
		}
		finally {
			Pop-Location
		}
	}

	_getSubmodulePaths | commitChanges

	Update-PowerShellConsoleVersion -Major:$Major -Minor:$Minor -Patch:$Patch 
	
	$ProfileConfig.Module.InstallPath | commitChanges "Main Console Repo..."

	if ($script:changesCommited) {
		Write-Host -ForegroundColor Green "Changes commited successfully!"
	} else {
		Write-Host -ForegroundColor Red "No changes commited"
	}
}
