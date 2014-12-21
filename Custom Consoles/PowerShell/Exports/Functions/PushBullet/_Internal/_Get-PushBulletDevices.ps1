function _Get-PushBulletDevices {
	if (-not ($ProfileConfig.Temp.ContainsKey("PushBulletDevices"))) {
		$result = _Send-PushBulletApiRequest -Method Get -Uri "https://api.pushbullet.com/v2/devices"

		$powershellSymbols = Get-PowerShellSymbols

		$ProfileConfig.Temp.PushBulletDevices = $result.devices | 
												? { $_.active -eq "True" -and $_.pushable -eq "True" } | 
												% { @{Name = (Remove-PowerShellSymbols $_.nickname); Id = $_.iden} }
	}

	return $ProfileConfig.Temp.PushBulletDevices
}