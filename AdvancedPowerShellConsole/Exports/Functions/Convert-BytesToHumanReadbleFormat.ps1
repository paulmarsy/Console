function Convert-BytesToHumanReadbleFormat {
	param(
		$InputBytes,
		$Precision = "2"
	)

	$suffixes = @("B", "KB", "MB", "GB", "TB", "PB", "EB")
	if ($InputBytes -eq 0) {
		return "0$($suffixes[0])"
	}

	$bytes = [System.Math]::Abs($InputBytes)
	$order = [Convert]::ToInt32([System.Math]::Floor([System.Math]::Log($bytes, 1024)))
	$num = [System.Math]::Round($bytes / [System.Math]::Pow(1024, $order), $Precision)

	$humanReadableFormat = "$([System.Math]::Sign($InputBytes) * $num)$($suffixes[$order])"

	return $humanReadableFormat
}