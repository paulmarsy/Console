function Send-Email {
	[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$To,
        [Parameter(Mandatory=$true)]$Subject,
        [Parameter(Mandatory=$true)]$Body
    )

	$emailCredentials = Get-ProtectedProfileConfigSetting -Name "EmailCredentials"
	$securePassword = New-Object -Type System.Security.SecureString 
	$securePassword.SetReadOnly($emailCredentials.Password)
    $credential = New-Object -Type System.Management.Automation.PSCredential -ArgumentList @($emailCredentials.UserName, $securePassword)

	Send-MailMessage -To $To -From $ProfileConfig.Email.From -Credential $credential -Subject $Subject -Body $Body
}