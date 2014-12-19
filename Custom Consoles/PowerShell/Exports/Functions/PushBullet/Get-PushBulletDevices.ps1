function Get-PushBulletDevices
{
	$devices = _Get-PushBulletDevices
	if ($null -eq $devices) { return }

	return ($devices | % Name)
}