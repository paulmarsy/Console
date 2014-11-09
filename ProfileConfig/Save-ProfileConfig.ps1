function Save-ProfileConfig {
        $config = Get-Variable -Name ProfileConfig -ValueOnly -Scope Global
        $configFile = $config.Module.ProfileConfigFile
        
        @("General", "Module", "Temp") | % { $config.Remove($_) }
        
		ConvertTo-Json -InputObject $config -Compress | Set-Content -Path $configFile
}