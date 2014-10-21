function New-ProfileConfig {
	param($OverrideProfileConfig)
	$o = $OverrideProfileConfig

	$newProfileConfig = @{
		General = @{
			UserFolder								= $AdvancedPowerShellConsoleUserFolder
			TempFolder								= $AdvancedPowerShellConsoleTempFolder
			UserScriptsFolder						= $AdvancedPowerShellConsoleUserScriptsFolder
		}
		Module = @{
			ProfileHookFile							= $PROFILE.CurrentUserAllHosts
			ProfileConfigFile						= $ProfileConfigFile
			InstallPath								= $InstallPath
			AppSettingsFolder						= $AdvancedPowerShellConsoleAppSettingsFolder
			Version 								= @{
														Current		= Get-Content -Path (Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "Version.semver")
														Available	= Get-Content -Path (Join-Path $InstallPath "Install\Version.semver")
														IsUpToDate	= { $ProfileConfig.Module.Version.Current -eq $ProfileConfig.Module.Version.Available }
													}
		}
		PowerShell = @{
			FormatEnumerationLimit	= ?: { $o.PowerShell.FormatEnumerationLimit }	{ $o.PowerShell.FormatEnumerationLimit }	{ -1 } 						-NotNullCheck 
			PSEmailServer			= ?: { $o.PowerShell.PSEmailServer }			{ $o.PowerShell.PSEmailServer }				{ "" }						-NotNullCheck 
		}
		Git = @{
			Name					= ?: { $o.Git.Name }							{ $o.Git.Name }								{ "Your Name" }				-NotNullCheck 
			Email					= ?: { $o.Git.Email }							{ $o.Git.Email }							{ "email@example.com" }		-NotNullCheck 
		}
		TFS = @{
			Server					= ?: { $o.TFS.Server }							{ $o.TFS.Server }							{ "Your TFS Server URL" } 	-NotNullCheck 
		}
		ProtectedConfig = @{
			CurrentUser				= ?: { $o.ProtectedConfig.CurrentUser }			{ $o.ProtectedConfig.CurrentUser }			{ $null }					-NotNullCheck 
			LocalMachine			= ?: { $o.ProtectedConfig.LocalMachine }		{ $o.ProtectedConfig.LocalMachine }			{ $null }					-NotNullCheck 
		}
		Temp = @{
			# ConnectionManager
			# ModuleExports
			# UserScriptExports
		} 
	}

	return $newProfileConfig
}