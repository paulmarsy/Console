function New-ProfileConfig {
	param($OverrideProfileConfig)

	function OverridableConfigSetting {
		param(
			[Parameter(Position=0,Mandatory=$true)]$Path,
			[Parameter(Position=1)]$Default
		)

		$temp = $OverrideProfileConfig
		$Path.Split(".") | % { $temp = Select-Object -InputObject $temp -Property $_ | Select-Object -ExpandProperty $_ }

		return (?:	{ $null -ne $temp } `
					{ $temp } `
					{ $Default })
	}

	return @{
		<################################################## Auto-generated Configuration Settings		##################################################>
		General = @{
			UserFolder								= $PowerShellConsoleUserFolder
			TempFolder								= (Join-Path $PowerShellConsoleUserFolder "Temp")
			UserScriptsFolder						= (Join-Path $PowerShellConsoleUserFolder "User Scripts")
		}
		Module = @{
			ProfileHookFile							= $PROFILE.CurrentUserAllHosts
			ProfileConfigFile						= $ProfileConfigFile
			InstallPath								= $InstallPath
			AppSettingsFolder						= $PowerShellConsoleAppSettingsFolder
			Version 								= @{
														Current		= Get-Content -Path (Join-Path $PowerShellConsoleAppSettingsFolder "Version.semver")
														Available	= Get-Content -Path (Join-Path $InstallPath "Install\Version.semver")
														IsUpToDate	= { $ProfileConfig.Module.Version.Current -eq $ProfileConfig.Module.Version.Available }
													}
		}
		Temp = @{
			# ConnectionManager
			# ModuleExports
			# UserScriptExports
		} 
		<################################################## User definable Configuration Settings		##################################################>
		PowerShell = @{
			FormatEnumerationLimit	= (OverridableConfigSetting "PowerShell.FormatEnumerationLimit"		-1)
			PSEmailServer			= (OverridableConfigSetting "PowerShell.PSEmailServer"				"")
		}
		Git = @{
			Name					= (OverridableConfigSetting "Git.Name"								"Your Name")
			Email					= (OverridableConfigSetting "Git.Email"								"email@example.com")
		}
		TFS = @{
			Server					= (OverridableConfigSetting "TFS.Server"							"Your TFS Server URL")
		}
		ProtectedConfig = @{
			CurrentUser				= (OverridableConfigSetting "ProtectedConfig.CurrentUser"			$null)
			LocalMachine			= (OverridableConfigSetting "ProtectedConfig.LocalMachine"			$null)
		}
	}
}