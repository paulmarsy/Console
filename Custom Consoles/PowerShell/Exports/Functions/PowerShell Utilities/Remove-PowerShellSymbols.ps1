function Remove-PowerShellSymbols
{
	param(
		[Parameter(Mandatory=$true)]$InputObject,
		[switch]$IncludeExtended
	)

	$cleanedInputedObject = $InputObject

	Get-PowerShellSymbols -IncludeExtended:$IncludeExtended | % { $cleanedInputedObject = $cleanedInputedObject.RemoveString($_) }

	return $cleanedInputedObject
}

