function _Send-PushBulletApiRequest {
	param(
		[Parameter(Mandatory=$true)]$Uri,
		[Parameter(Mandatory=$true)][Microsoft.PowerShell.Commands.WebRequestMethod]$Method,
		$Body
	)

	$accessToken = _Get-PushBulletAccessToken
	if (-not $accessToken) { return $accessToken }

	try {
		return (Invoke-RestMethod	-Method:$Method `
									-Uri:$Uri `
									-Credential $accessToken `
									-Headers @{"Content-Type" = "application/json"} `
									-Body:$Body)
	}
	catch {
		Write-Error "Error accessing PushBullet: $($_.Exception.Message)"
		return $null
	}
}