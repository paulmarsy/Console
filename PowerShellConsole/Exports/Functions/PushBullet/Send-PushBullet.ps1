function Send-PushBullet
{
	param(
		[Parameter(Mandatory=$true)]$Message
	)

	if (-not (Test-ProtectedProfileConfigSetting -Name "PushBulletAccessToken")) {
		Write-Host -ForegroundColor Red "ERROR: Access Token not set, use Set-PushBulletAccessToken to set it"
		return
	}

	$accessToken = New-Object -Type System.Management.Automation.PSCredential ((Get-ProtectedProfileConfigSetting -Name "PushBulletAccessToken"), (New-Object -Type System.Security.SecureString))

	$message = ConvertTo-Json -InputObject @{type = "note"; title = "PowerShell";  body = $Message } -Compress
	Invoke-RestMethod -Method Post -Uri "https://api.pushbullet.com/v2/pushes" -Credential $accessToken -Headers @{"Content-Type" = "application/json"} -Body $message | Out-Null

	Write-Host -ForegroundColor Green "PushBullet sent."
}