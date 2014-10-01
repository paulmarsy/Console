function _updateGitHub {
	Push-Location $ProfileConfig.General.InstallPath
    try {
    	$outputPath = [System.IO.Path]::GetTempFileName()
    	Start-Process -FilePath "git.exe" -ArgumentList "remote --verbose update" -WindowStyle Hidden -Wait -RedirectStandardOutput $outputPath
    	$output = Get-Content -Path $outputPath
    	Remove-Item -Path $outputPath
    	return $output
	}
	finally {
		Pop-Location
	}
}