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
			UserFolder								= $PowerShellConsoleConstants.UserFolders.Root
			TempFolder								= $PowerShellConsoleConstants.UserFolders.TempFolder
			UserScriptsFolder						= $PowerShellConsoleConstants.UserFolders.UserScriptsFolder
			UserScriptsIncludeFile					= $PowerShellConsoleConstants.UserFolders.UserScriptsIncludeFile
			UserScriptsAutoFolder					= $PowerShellConsoleConstants.UserFolders.UserScriptsAutoFolder
			IsAdmin									= ($PowerShellConsoleConstants.IsAdmin -eq 1)
		}
		Module = @{
			ProfileHookFile							= $PowerShellConsoleConstants.HookFiles.PowerShell
			ProfileConfigFile						= $ProfileConfigFile
			InstallPath								= $PowerShellConsoleConstants.InstallPath
			AppSettingsFolder						= $PowerShellConsoleConstants.UserFolders.AppSettingsFolder
			Version 								= $PowerShellConsoleConstants.Version
		}
		ConsolePaths = @{
			CommandPrompt 							= (Join-Path $PowerShellConsoleConstants.InstallPath "Custom Consoles\CommandPrompt")
			PowerShell 								= (Join-Path $PowerShellConsoleConstants.InstallPath "Custom Consoles\PowerShell")
		}
		Temp = @{
			# ConnectionManager
			# UserScriptExports
		}
		<################################################## User definable Configuration Settings		##################################################>
		PowerShell = @{
			FormatEnumerationLimit	= (OverridableConfigSetting "PowerShell.FormatEnumerationLimit"		-1)
			PSEmailServer			= (OverridableConfigSetting "PowerShell.PSEmailServer"				"")
		}
		Email = @{
			From					= (OverridableConfigSetting "Email.From"							"email@example.com")
			NoteTo					= (OverridableConfigSetting "Email.NoteTo"							"email@example.com")
		}
		Git = @{
			Name					= (OverridableConfigSetting "Git.Name"								"Your Name")
			Email					= (OverridableConfigSetting "Git.Email"								"email@example.com")
			LastAutoSyncTickTime	= (([long](OverridableConfigSetting "Git.LastAutoSyncTickTime"		0)))
			SyncIntervalInSeconds	= ([int](60 * 60 * 12))
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
