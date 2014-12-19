[CmdletBinding()]
param (
	[Parameter(Mandatory=$true,ParameterSetName="DisplayInfo")][switch]$DisplayInfo,
	[Parameter(Mandatory=$true,ParameterSetName="PowerShellConsoleUserFolders")][switch]$PowerShellConsoleUserFolders,
	[Parameter(Mandatory=$true,ParameterSetName="General")][switch]$General,
	[Parameter(Mandatory=$true,ParameterSetName="Finalize")][switch]$Finalize
)

Set-StrictMode -Version Latest

. "..\Load Dependencies.ps1"

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
		Push-Location "PowerShell Console User Folders"
		Get-ChildItem -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }
		Pop-Location
		Write-InstallMessage -Type Success "Uninstalling PowerShell Console User Folders Done"
	}
	"General"{
		Write-InstallMessage -EnterNewScope "Uninstalling General Settings"
		Push-Location "General"
		Get-ChildItem -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }
		Pop-Location
		Write-InstallMessage -Type Success "Uninstalling General Settings Done"
	}
	"Finalize" {
		Write-InstallMessage -EnterNewScope "Finalizing uninstallation"
		Push-Location "Finalization"
		Get-ChildItem -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }
		Pop-Location
		Write-InstallMessage -Type Success "Finalization done"

		Write-Host
		Write-InstallMessage -Type Success "Completed uninstallation!"
		Write-Host
	}
}
