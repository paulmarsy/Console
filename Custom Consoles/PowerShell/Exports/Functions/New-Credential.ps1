function New-Credential {
	param(
		[Parameter(Mandatory=$true)]$UserName,
		[Parameter(Mandatory=$true)]$Password
	)

	$securePassword = New-Object -TypeName System.Security.SecureString
	$Password.ToCharArray() | % { $securePassword.AppendChar($_) }

	return (New-Object System.Management.Automation.PSCredential($UserName, $securePassword))
}