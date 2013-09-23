[CmdletBinding()]
param (
	[Parameter(Mandatory=$true,ParameterSetName="PreReqCheck")][switch]$PreReqCheck,
	[Parameter(Mandatory=$true,ParameterSetName="Mixed")][switch]$Mixed,
	[Parameter(Mandatory=$true,ParameterSetName="Specific")][switch]$Specific
)

Set-StrictMode -Version Latest

$global:MessageScope = 0
Get-ChildItem ".\Install Helpers" -Filter *.ps1 | % { . $_.FullName }

$InstallPath = Resolve-Path (Join-Path $pwd.Path '..\..\')

switch ($PSCmdlet.ParameterSetName)
{
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
}