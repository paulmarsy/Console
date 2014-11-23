param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

if (Get-ChildItem -Path $ProfileConfig.General.TempFolder) {
	Write-Host
	$clearPowerShellTempFolder = $Host.UI.PromptForChoice("Clear PowerShell Temp Folder", "Files detected in the PowerShell Temp folder, do you want to remove them?", ([System.Management.Automation.Host.ChoiceDescription[]](
		(New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Clear the PowerShell Temp folder"),
		(New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not remove the files")
	)), 1)

	if ($clearPowerShellTempFolder -eq 0) {
		Get-ChildItem -Path $ProfileConfig.General.TempFolder -Recurse | Remove-Item -Force
	}
	Write-Host
}