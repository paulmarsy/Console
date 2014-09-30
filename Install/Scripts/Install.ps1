[CmdletBinding()]
param (
	[Parameter(Mandatory=$true,ParameterSetName="DisplayInfo")][switch]$DisplayInfo,
	[Parameter(Mandatory=$true,ParameterSetName="PreReqCheck")][switch]$PreReqCheck,
	[Parameter(Mandatory=$true,ParameterSetName="Specific")][switch]$Specific,
	[Parameter(Mandatory=$true,ParameterSetName="Mixed")][switch]$Mixed,
	[Parameter(Mandatory=$true,ParameterSetName="Finalize")][switch]$Finalize,
	[Parameter(ParameterSetName="Finalize")][switch]$StartAfterInstall,
	[Parameter(ParameterSetName="Finalize")]$WorkingDirectory
)

Set-StrictMode -Version Latest

$global:MessageScope = 0
Get-ChildItem ".\Install Helpers" -Filter *.ps1 | % { . $_.FullName }

$InstallPath = Resolve-Path (Join-Path $pwd.Path '..\..\')
$AdvancedPowerShellConsoleVersionToken = Get-Content -Path "..\Install.Version"

switch ($PSCmdlet.ParameterSetName)
{
	"DisplayInfo" {
		Write-InstallMessage -EnterNewScope "Install Information"
		Write-InstallMessage -Type Info "Install Path: $InstallPath"
		Write-InstallMessage -Type Info "Advanced PowerShell Console Version: $AdvancedPowerShellConsoleVersionToken"	
	}
	"PreReqCheck" { 
		Write-InstallMessage -EnterNewScope "Checking for prerequisites"
		$prerequisitesMet = & ".\Prerequisites Check.ps1"
		if (-not $prerequisitesMet) {
			Write-InstallMessage -Type Error "Prerequisites not met. Exiting installation."
			exit 1
		}
		Write-InstallMessage -Type Success "All prerequisites met"
	}
	"Specific" {
		if ([System.Environment]::Is64BitProcess) { $type = "64bit" }
		else { $type = "32bit" }

		Write-InstallMessage -EnterNewScope ("Configuring {0} Bitness Settings" -f $type)
		Push-Location "Specific Platform"
		Get-ChildItem -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }
		Pop-Location
		Write-InstallMessage -Type Success ("Configuring {0} Bitness Done" -f $type)
	}
	"Mixed"{
		Write-InstallMessage -EnterNewScope "Configuring Mixed Bitness Settings"
		Push-Location "Mixed Platform"
		Get-ChildItem -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }
		Pop-Location
		Write-InstallMessage -Type Success "Configuring Mixed Bitness Done"
	}
	"Finalize" {
		Write-InstallMessage -Type Success "Completed installation!"
		if ($StartAfterInstall) {
			Write-InstallMessage -Type Success "Attempting to start Advanced PowerShell Console..."

			if ($null -eq $WorkingDirectory) {
				$WorkingDirectory = Split-Path -Qualifier $InstallPath
			}
			Start-Process -FilePath "$(Join-Path $InstallPath "Third Party\Console\ConEmu64.exe")" -ArgumentList "/cmd powershell.exe -NoExit" -WorkingDirectory $WorkingDirectory
		}
	}
}