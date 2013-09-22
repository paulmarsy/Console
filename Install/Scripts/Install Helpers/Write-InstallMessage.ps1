function Write-InstallMessage {
	[CmdletBinding(DefaultParameterSetName="Default")]
	param (
		[Parameter(Mandatory=$true)]$InstallMessage,
		[ValidateSet("Default","Success","Warning","Error")]
		$Type = "Default",
		[switch]$EnterNewScope
	)

	switch ($Type)
	{
		"Default" {
			Write-Host ("{0}$InstallMessage... " -f ("`t" * $global:MessageScope))
		}
		"Success" {
			Write-Host -ForegroundColor Green $InstallMessage
		}
		"Warning" {
			Write-Host -ForegroundColor Yellow "WARNING: $InstallMessage"
		}
		"Error" {
			Write-Host -ForegroundColor Red "ERROR: $InstallMessage"
		}
	}

	if ($EnterNewScope) {
		$global:MessageScope++
	}
}