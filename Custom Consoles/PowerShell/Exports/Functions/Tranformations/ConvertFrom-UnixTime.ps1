function ConvertFrom-UnixTime
{
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)][int]$UnixTime
	)

	$epoch = _Get-EpochDateTime

	$dateTime = $epoch.AddSeconds($UnixTime)

	return $dateTime
}