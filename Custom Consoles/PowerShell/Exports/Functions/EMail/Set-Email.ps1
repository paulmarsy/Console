function Set-Email {
	[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$EmailServer,
        [Parameter(Mandatory=$true)]$From
    )
		
	$emailCredentials = Get-Credential -Username ("{0}\{1}" -f ([Environment]::UserDomainName), ([Environment]::UserName)) -Message "Enter your email logon credentials"
	Set-ProtectedProfileConfigSetting -Name "EmailCredentials" -Value @{
		UserName = $emailCredentials.UserName
		Password = $emailCredentials.Password.Peek()
	} -Force

	$ProfileConfig.PowerShell.PSEmailServer = $EmailServer
	$global:PSEmailServer = $EmailServer
	$ProfileConfig.Email.From = $From
}