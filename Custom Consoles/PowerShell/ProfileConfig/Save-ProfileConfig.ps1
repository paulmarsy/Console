function Save-ProfileConfig {
	param(
		[switch]$Quiet
	)

	try {
		if (-not $Quiet) { Write-Host -ForegroundColor Cyan -NoNewLine "Saving ProfileConfig... " }

		$config = Get-Variable -Name ProfileConfig -ValueOnly -Scope Global
		$configClone = $config.Clone()
		$configFile = $configClone.Module.ProfileConfigFile

		@("General", "Module", "Temp", "ConsolePaths") | % { $configClone.Remove($_) }

		ConvertTo-Json -InputObject $configClone | Set-Content -Path $configFile

		if (-not $Quiet) { Write-Host -ForegroundColor Green "Done." }
	}
	catch {
		Write-Host
		Write-Error "Error saving ProfileConfig! $_"
	}
}