function _Get-PushBulletDevices {
	$result = _Send-PushBulletApiRequest -Method Get -Uri "https://api.pushbullet.com/v2/devices"
	if ($null -eq $result) { return }

	return ($result.devices | ? { $_.active -eq "True" -and $_.pushable -eq "True" } | % { @{Name = $_.nickname; Id = $_.iden} })
}