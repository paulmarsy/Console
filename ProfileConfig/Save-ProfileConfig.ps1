function Save-ProfileConfig {
	param(
		[switch]$Quiet
	)

	try {
		if (-not $Quiet) { Write-Host -ForegroundColor Cyan -NoNewLine "Saving ProfileConfig... " }

		$config = Get-Variable -Name ProfileConfig -ValueOnly -Scope Global
		$configFile = $config.Module.ProfileConfigFile

		@("General", "Module", "Temp") | % { $config.Remove($_) }

		ConvertTo-Json -InputObject $config -Compress | Set-Content -Path $configFile

		if (-not $Quiet) { Write-Host -ForegroundColor Green "Done." }
	}
	catch {
		Write-Host -ForegroundColor Red "`nError saving ProfileConfig! $_"
	}
}