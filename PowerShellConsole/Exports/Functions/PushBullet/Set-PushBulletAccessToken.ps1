function Set-PushBulletAccessToken
{
	param(
		[Parameter(Mandatory=$true)]$AccessToken,
		[switch]$Force
	)

	if ((Test-ProtectedProfileConfigSetting -Name "PushBulletAccessToken") -and -not $Force) {
			Write-Host -ForegroundColor Red "ERROR: Access Token already set, use -Force to overwrite it"
			return
	}

	Set-ProtectedProfileConfigSetting -Name "PushBulletAccessToken" -Value $AccessToken -Force
}