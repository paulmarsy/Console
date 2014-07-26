function Send-Email {
	[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$To,
        [Parameter(Mandatory=$true)]$Subject,
        [Parameter(Mandatory=$true)]$Body
    )

    $password = ConvertTo-SecureString $ProfileConfig.EMail.Password
    $credential = New-Object System.Management.Automation.PSCredential ($ProfileConfig.EMail.Username, $password)

	Send-MailMessage -To $To -Subject $Subject -Body $Body -UseSsl -Port 587 -From $ProfileConfig.EMail.From -Credential $credential
}