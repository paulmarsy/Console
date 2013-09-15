[CmdletBinding()]
param (
	[Parameter(Mandatory=$true,ParameterSetName="PreReqCheck")][switch]$PreReqCheck,
	[Parameter(Mandatory=$true,ParameterSetName="Mixed")][switch]$Mixed,
	[Parameter(Mandatory=$true,ParameterSetName="Specific")][switch]$Specific
)

Set-StrictMode -Version Latest

if ($PreReqCheck) {
	"Checking for prerequisites..."
	$prerequisitesMet = & ".\Prerequisites Check.ps1"
	if (-not $prerequisitesMet) {
		"ERROR: Prerequisites not met. Exiting installation."
		exit 1
	}
}

$InstallPath = Resolve-Path (Join-Path $pwd.Path '..\..\')

if ($Specific) {
	if ([System.Environment]::Is64BitProcess) { $type = "64bit" }
	else { $type = "32bit" }

	"Configuring {0} Bitness Console..." -f $type
	Get-ChildItem ".\Specific Platform" | % {
	    & $_.FullName
	}
}

if ($Mixed) {
	"Configuring Mixed Bitness Console..."
	Get-ChildItem ".\Mixed Platform" | % {
	    & $_.FullName
	}
}