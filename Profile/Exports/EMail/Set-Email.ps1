function Set-Email {
	[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$EmailServer,
        [Parameter(Mandatory=$true)]$From,
        [Parameter(Mandatory=$true)]$Username
    )
	
	$password = Read-Host "Enter the password for the '$Username'" -AsSecureString

	$ProfileConfig.PowerShell.PSEmailServer = $EmailServer
	$ProfileConfig.EMail.From = $From
	$ProfileConfig.EMail.Username = $Username
	$ProfileConfig.EMail.Password = (ConvertFrom-SecureString $password)
}
@{Function = "Set-Email"}