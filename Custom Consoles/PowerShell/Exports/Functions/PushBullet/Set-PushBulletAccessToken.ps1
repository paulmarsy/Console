function Set-PushBulletAccessToken
{
	param(
		[Parameter(Mandatory=$true)]$AccessToken,
		[switch]$Force
	)

	if ((Test-ProtectedProfileConfigSetting -Name "PushBulletAccessToken") -and -not $Force) {
			throw "Access Token already set, use -Force to overwrite it"
	}

	Set-ProtectedProfileConfigSetting -Name "PushBulletAccessToken" -Value $AccessToken -Force
}