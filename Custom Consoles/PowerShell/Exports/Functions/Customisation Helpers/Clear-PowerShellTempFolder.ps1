function Clear-PowerShellTempFolder {
	Get-ChildItem -Path $ProfileConfig.General.TempFolder | Remove-Item -Recurse -Force
}