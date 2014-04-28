function New-ProfileConfig {
	param($overrideProfileConfig)
	$o = $overrideProfileConfig

	$ProfileConfig = @{
		General = @{
			InstallPath				= $InstallPath
			ProfileConfigFile		= $profileConfigFile
			PowerShellScriptsFolder	= (Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Scripts")
		}
		PowerShell = @{
			FormatEnumerationLimit	= $(if ($o.PowerShell.FormatEnumerationLimit)	{ $o.PowerShell.FormatEnumerationLimit }	else { -1 })
			PSEmailServer			= $(if ($o.PowerShell.PSEmailServer)			{ $o.PowerShell.PSEmailServer }				else { "" })
		}
		Git = @{
			Name					= $(if ($o.Git.Name)							{ $o.Git.Name }								else { "Your Name" })
			Email					= $(if ($o.Git.Email)							{ $o.Git.Email }							else { "email@example.com" })
		}
		TFS = @{
			Server					= $(if ($o.TFS.Server)							{ $o.TFS.Server }							else { "Your TFS Server URL" })
		}
		EMail = @{
			From					= $(if ($o.EMail.From)							{ $o.EMail.From }							else { "email@example.com" })
			Username				= $(if ($o.EMail.Username)						{ $o.EMail.Username }						else { "email@example.com" })
			Password				= $(if ($o.EMail.Password)						{ $o.EMail.Password }						else { "Password1" })

		}
	}

	$ProfileConfig
}