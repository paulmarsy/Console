[CmdletBinding()]
param (
	[Parameter(Mandatory=$true,ParameterSetName="DisplayInfo")][switch]$DisplayInfo,
	[Parameter(Mandatory=$true,ParameterSetName="PowerShellConsoleUserFolders")][switch]$PowerShellConsoleUserFolders,
	[Parameter(Mandatory=$true,ParameterSetName="General")][switch]$General,
	[Parameter(Mandatory=$true,ParameterSetName="Finalize")][switch]$Finalize
)

Set-StrictMode -Version Latest

trap {
	(Get-Host).SetShouldExit(1)
}

. "..\Load Dependencies.ps1"

$processUninstallStepFiles = {
	param ($Folder)
	Push-Location $Folder
	Get-ChildItem -Filter *.ps1 -File | Sort-Object Name | % { & $_.FullName }
	Pop-Location
}

switch ($PSCmdlet.ParameterSetName)
{
	"DisplayInfo" {
		Write-InstallMessage -EnterNewScope "Uninstall Information"
		Write-InstallMessage -Type Info "Install Path: $($PowerShellConsoleConstants.InstallPath)"
		Write-InstallMessage -Type Info "Installed Version: $($PowerShellConsoleConstants.Version.InstalledVersion)"
		Write-InstallMessage -Type Info "Available Version: $($PowerShellConsoleConstants.Version.CurrentVersion)"
	}
	"PowerShellConsoleUserFolders" {
		Write-InstallMessage -EnterNewScope "Uninstalling PowerShell Console User Folders"
		& $processUninstallStepFiles "PowerShell Console User Folders"
		Write-InstallMessage -Type Success "Uninstalling PowerShell Console User Folders Done"
	}
	"General"{
		Write-InstallMessage -EnterNewScope "Uninstalling General Settings"
		& $processUninstallStepFiles "General"
		Write-InstallMessage -Type Success "Uninstalling General Settings Done"
	}
	"Finalize" {
		Write-InstallMessage -EnterNewScope "Finalizing uninstallation"
		& $processUninstallStepFiles "Finalization"
		Write-InstallMessage -Type Success "Finalization done"

		Write-Host
		Write-InstallMessage -Type Success "Completed uninstallation!"
		Write-Host
	}
}
