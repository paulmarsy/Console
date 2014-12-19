function _Get-PushBulletAccessToken {
	$accessToken = Get-ProtectedProfileConfigSetting -Name "PushBulletAccessToken"
	if ($accessToken | Is NullOrWhiteSpace -Bool) {
		Write-Error "Access Token not set, use Set-PushBulletAccessToken to set it"
		return $null
	}

	return (New-Object	-Type System.Management.Automation.PSCredential `
						-ArgumentList @($accessToken, (New-Object -Type System.Security.SecureString)))
}