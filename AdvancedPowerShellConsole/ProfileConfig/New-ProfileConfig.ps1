function New-ProfileConfig {
	param($OverrideProfileConfig)
	$o = $OverrideProfileConfig

	. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
	. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")

	$newProfileConfig = @{
		General = @{
			InstallPath								= $InstallPath
			PowerShellProfileHookFile				= $PROFILE.CurrentUserAllHosts
			ProfileConfigFile						= $profileConfigFile
			PowerShellScriptsFolder					= (Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Scripts")
		}
		AdvancedPowerShellConsoleVersion = @{
			Current									= Get-Content -Path $PROFILE.CurrentUserAllHosts | Select-Object -Index 1
			Available								= Get-Content -Path (Join-Path $InstallPath "Install\Install.Version")
		}
		PowerShell = @{
			FormatEnumerationLimit	= ?: -NotNullCheck { $o.PowerShell.FormatEnumerationLimit }	{ $o.PowerShell.FormatEnumerationLimit }	{ -1 }
			PSEmailServer			= ?: -NotNullCheck { $o.PowerShell.PSEmailServer }			{ $o.PowerShell.PSEmailServer }				{ "" }
		}
		Git = @{
			Name					= ?: -NotNullCheck { $o.Git.Name }							{ $o.Git.Name }								{ "Your Name" }
			Email					= ?: -NotNullCheck { $o.Git.Email }							{ $o.Git.Email }							{ "email@example.com" }
		}
		TFS = @{
			Server					= ?: -NotNullCheck { $o.TFS.Server }						{ $o.TFS.Server }							{ "Your TFS Server URL" }
		}
		EMail = @{
			SystemAccountName		= ?: -NotNullCheck { $o.EMail.SystemAccountName }			{ $o.EMail.SystemAccountName }				{ "Default" }
		}
		ProtectedConfig = @{
			CurrentUser				= ?: -NotNullCheck { $o.ProtectedConfig.CurrentUser }		{ $o.ProtectedConfig.CurrentUser }			{ $null }
			LocalMachine			= ?: -NotNullCheck { $o.ProtectedConfig.LocalMachine }		{ $o.ProtectedConfig.LocalMachine }			{ $null }
		}
	}

	# Post Processing
	$newProfileConfig.AdvancedPowerShellConsoleVersion.UpToDate = $newProfileConfig.AdvancedPowerShellConsoleVersion.Current -eq $newProfileConfig.AdvancedPowerShellConsoleVersion.Available

	return $newProfileConfig
}