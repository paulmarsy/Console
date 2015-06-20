function Get-TempFile {
	param(
		[ValidateSet("CurrentDirectory", "ConsoleTempDirectory", "UserTempDirectory")]$Path = "CurrentDirectory"
	)
	
	$tempDirectory = switch ($Path) {
		"CurrentDirectory" { $PWD.Path }
		"ConsoleTempDirectory" { $ProfileConfig.General.TempFolder }
		"UserTempDirectory" { [System.IO.Path]::GetTempPath() }
	}
	$tempFileName = [System.IO.Path]::ChangeExtension(([System.IO.Path]::GetRandomFileName()), "tmp")
	$filePath = Join-Path $tempDirectory $tempFileName
	
    Set-File -Path $filePath

    return $filePath
}