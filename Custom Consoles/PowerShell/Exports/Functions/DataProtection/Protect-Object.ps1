function Protect-Object {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]$InputObject,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	$jsonRepresentation = ConvertTo-Json -InputObject $InputObject -Compress -Depth ([Int32]::MaxValue)

	return (Protect-String -InputObject $jsonRepresentation -Scope $Scope)
}