function Get-TempFile {
	$tempFileName = [System.IO.Path]::ChangeExtension(([System.IO.Path]::GetRandomFileName()), "tmp")
	$filePath = Join-Path $ProfileConfig.General.TempFolder $tempFileName
    Set-File -Path $filePath

    return $filePath
}