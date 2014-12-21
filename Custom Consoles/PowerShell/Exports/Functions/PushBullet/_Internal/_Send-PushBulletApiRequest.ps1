function _Send-PushBulletApiRequest {
	param(
		[Parameter(Mandatory=$true)]$Uri,
		[Parameter(Mandatory=$true)][Microsoft.PowerShell.Commands.WebRequestMethod]$Method,
		$Body
	)

	try {
		$accessToken = _Get-PushBulletAccessToken

		return (Invoke-RestMethod	-Method:$Method `
									-Uri:$Uri `
									-Credential $accessToken `
									-Headers @{"Content-Type" = "application/json"} `
									-Body:$Body)
	}
	catch {
		throw "Error accessing PushBullet: $($_.Exception.Message)"
	}
}