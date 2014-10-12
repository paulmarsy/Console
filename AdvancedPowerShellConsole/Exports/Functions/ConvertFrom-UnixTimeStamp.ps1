function ConvertFrom-UnixTimeStamp
{
	[CmdletBinding()]
	param(
	 [Parameter(Mandatory=$true)]$UnixTimeStamp
	)

	$epoch = Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0 

	return ($epoch.AddSeconds($UnixTimeStamp))
}