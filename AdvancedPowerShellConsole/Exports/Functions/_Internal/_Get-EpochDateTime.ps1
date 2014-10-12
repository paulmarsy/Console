function _Get-EpochDateTime
{
	param(
		[ValidateSet("UnixTime", "DateTime")]$Type = "DateTime"
	)

	$epoch = New-Object -TypeName System.DateTime -ArgumentList @(1970, 1, 1, 0, 0, 0, 0, [System.DateTimeKind]::Utc)

	switch ($Type) {
		"DateTime" { return $epoch }
		"UnixTime" { return $epoch.TotalSeconds }
	}
}