function New-ProfileConfig {
	param($OverrideProfileConfig)
	$o = $OverrideProfileConfig

	$newProfileConfig = @{
		General = @{
			InstallPath								= $InstallPath
			PowerShellProfileHookFile				= $PROFILE.CurrentUserAllHosts
			ProfileConfigFile						= $profileConfigFile
			PowerShellScriptsFolder					= (Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Scripts")
		}
		AdvancedPowerShellConsoleVersion = @{
			Current									= Get-Content -Path (Join-Path (Split-Path $PROFILE.CurrentUserAllHosts -Parent) "Version.txt")
			Available								= Get-Content -Path (Join-Path $InstallPath "Install\Version.txt")
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
	}

	# Post Processing
	$newProfileConfig.AdvancedPowerShellConsoleVersion.UpToDate = $newProfileConfig.AdvancedPowerShellConsoleVersion.Current -eq $newProfileConfig.AdvancedPowerShellConsoleVersion.Available

	return $newProfileConfig
}