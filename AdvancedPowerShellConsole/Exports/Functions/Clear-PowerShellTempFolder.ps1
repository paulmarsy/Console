function Clear-PowerShellTempFolder {
		Push-Location $ProfileConfig.General.PowerShellUserFolder
		Remove-Item $ProfileConfig.General.PowerShellTempFolder -Force -Recurse
		New-Item $ProfileConfig.General.PowerShellTempFolder -Type Directory -Force | Out-Null
		Pop-Location
}