function Sync-ConsoleWithGitHub {
	param(
		[switch]$DontPullFromGitHub,
		[switch]$DontPushToGitHub,
		[ValidateSet("Prompt", "Auto", "None")]$UpdateConsole = "Prompt"
    )

	$reloadNeeded = $false
	try {
		_workOnConsoleWorkingDirectory {
			param($DontPullFromGitHub, $DontPushToGitHub, [ref]$reloadNeeded)

			Write-Host -ForegroundColor Cyan "Updating Git remotes from GitHub..."
			_invokeGitCommand "remote --verbose update --prune"

			if ((Assert-ConsoleIsInSync -Quiet -AssertIsFatal) -eq $false) { return }
	    		
	   		$currentBranch = _getCurrentBranch

	   		# Create local branch of remote tracking branches if they dont exist
			$local = & git --% rev-parse @
			$remote = & git --% rev-parse @{u}
			$base = & git --% merge-base @ @{u}

			if ($local -eq $remote) {
				Write-Host -ForegroundColor Green "Local Console Git repo is in sync with Github"
			} else {
				if ($remote -ne $base -and -not $DontPullFromGitHub) {
					Write-Host -ForegroundColor Cyan "Pulling Console changes from GitHub into Local Git repo..."
					_invokeGitCommand "pull --rebase origin"
					$reloadNeeded.Value = $true
				}
				if ($local -ne $base -and -not $DontPushToGitHub) {
					Write-Host -ForegroundColor Cyan "Pushing Console changes from Local Git repo into GitHub..."
					_invokeGitCommand "push origin"
				}
			}
	    } @($DontPullFromGitHub, $DontPushToGitHub, [ref]$reloadNeeded)
	}
	finally {
		_updateGitHubCmdletParameters
	}

	Sync-ProfileConfig -Quiet
	if (-not $ProfileConfig.AdvancedPowerShellConsoleVersion.UpToDate) {
		if ($UpdateConsole -eq "Prompt")  {
			$updateConsolePrompt = Show-ConfirmationPrompt -Caption "Reinstall Advanced PowerShell Console" -Message "It is recommended you reinstall the Advanced PowerShell Console as changes have been detected"
		}
		if ($UpdateConsole -eq "Auto" -or $updateConsolePrompt) {
			Reinstall-Console -AutomatedReinstall
		}
		if ($UpdateConsole -eq "None") {
			Write-Host -ForegroundColor Red "It is recommended you reinstall the Advanced PowerShell Console as changes were detected"
		}
	}

	if ($reloadNeeded) {
		if ($UpdateConsole -eq "Prompt") {
			$updateConsolePrompt = Show-ConfirmationPrompt -Caption "Restart Advanced PowerShell Console" -Message "It is recommended you restart the Advanced PowerShell Console as changes have been detected"
		}
	   	if ($UpdateConsole -eq "Auto" -or $updateConsolePrompt) {
	   		Restart-Console
	   	}
	   	if ($UpdateConsole -eq "None") {
			Write-Host -ForegroundColor Red "It is recommended you restart the Advanced PowerShell Console as changes were detected"
		}
	}
}