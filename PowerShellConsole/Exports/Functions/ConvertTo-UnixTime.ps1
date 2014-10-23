function ConvertTo-UnixTime
{
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)][System.DateTime]$DateTime
	)

	$epoch = _Get-EpochDateTime

	$unixtime = [Math]::Truncate(($DateTime.ToUniversalTime()).Subtract($epoch).TotalSeconds)

	return $unixtime
}