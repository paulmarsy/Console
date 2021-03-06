function Convert-DataSizeToHumanReadbleFormat {
	param(
		[long]$Size,
		[ValidateSet("Bits", "Bytes")]$Type = "Bytes",
		[ValidateRange(0,15)]$Precision = "2",
		[ValidateSet("N/A", "PerSecond", "PerMinute", "PerHour")]$Rate = "N/A"
	)

	$suffixes = @("b", "kb", "mb", "gb", "tb", "pb", "eb") | % { 
		$suffix = $_
		switch ($Type) {
			"Bits" { [System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($suffix) }
			"Bytes" { $suffix.ToUpper() }
		}
	}

	if ($Rate -ne "N/A") {
		$suffixes = $suffixes | % {
			$suffix = $_
			if ($Type -eq "Bits") {
				$suffix += "it"
			}
			switch ($Rate) {
				"PerSecond" { $suffix += "/s" }
				"PerMinute" { $suffix += "/m" }
				"PerHour" { $suffix += "/h" }
			}
			return $suffix
		}
	}

	if ($Size -eq 0) {
		return "0$($suffixes[0])"
	}

	switch ($Type) {
		"Bits" { $base = 1000 }
		"Bytes" { $base = 1024 }
	}

	$bytes = [System.Math]::Abs($Size)
	$order = [Convert]::ToInt32([System.Math]::Floor([System.Math]::Log($bytes, $base)))
	$num = [System.Math]::Round($bytes / [System.Math]::Pow($base, $order), $Precision)

	$humanReadableFormat = "$([System.Math]::Sign($Size) * $num)$($suffixes[$order])"

	return $humanReadableFormat
}