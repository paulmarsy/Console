function Clear-PowerShellTempFolder {
	try{
		Push-Location $ProfileConfig.General.UserFolder
		if (Test-Path $ProfileConfig.General.TempFolder) {
			Remove-Item $ProfileConfig.General.TempFolder -Force -Recurse
		}
		New-Item $ProfileConfig.General.TempFolder -Type Directory -Force | Out-Null
	}
	finally { 
		Pop-Location
	}
}