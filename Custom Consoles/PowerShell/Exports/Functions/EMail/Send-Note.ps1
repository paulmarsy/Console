function Send-Note {
	[CmdletBinding()]
    param(
		[Parameter(Mandatory=$true,ValueFromRemainingArguments=$true)][string]$Note
    )
	
	Send-Email -To $ProfileConfig.Email.NoteTo -Subject "Note" -Body $Note
}