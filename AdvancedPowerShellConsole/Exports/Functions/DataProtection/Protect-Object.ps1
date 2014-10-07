function Protect-Object {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]$Object,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	$jsonRepresentation = ConvertTo-Json -InputObject $Object -Compress -Depth ([Int32]::MaxValue)

	return (Protect-String -InputObject $jsonRepresentation -Scope $Scope)
}