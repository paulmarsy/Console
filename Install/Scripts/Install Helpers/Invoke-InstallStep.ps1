function Invoke-InstallStep {
	[CmdletBinding()]
	param (
		[switch]$EnterNewScope,
		[Parameter(Mandatory=$true)]$InstallMessage,
		[Parameter(Mandatory=$true)]$InstallStep
	)

	Write-Host -NoNewline ("{0}$InstallMessage... " -f ("`t" * $global:MessageScope))

	try {
		& $InstallStep
	}
	catch {
		Write-Host -ForegroundColor Red "ERROR!"
		throw
	}

	Write-Host -ForegroundColor Green "Done!"

	if ($EnterNewScope) {
		$global:MessageScope++
	}
}