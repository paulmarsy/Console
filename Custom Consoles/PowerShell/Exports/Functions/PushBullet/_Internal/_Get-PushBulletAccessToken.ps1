function _Get-PushBulletAccessToken {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
	param()
	
	$accessToken = Get-ProtectedProfileConfigSetting -Name "PushBulletAccessToken"
	if (Is -InputObject $accessToken NullOrWhiteSpace -Bool) {
		throw "Access Token not set, use Set-PushBulletAccessToken to set it"
	}

	return (New-Object	-Type System.Management.Automation.PSCredential `
						-ArgumentList @($accessToken, (New-Object -Type System.Security.SecureString)))
}