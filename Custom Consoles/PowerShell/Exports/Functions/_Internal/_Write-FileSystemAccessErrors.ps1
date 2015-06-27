function _Write-FileSystemAccessErrors {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
	param($ErrorArray)

		if ($ErrorArray.Count -eq 0) {
			return
		}

	Write-Host -ForegroundColor Yellow "File System Access Errors:"
	Write-Host -ForegroundColor Yellow "`tTotal Errors: $($ErrorArray.Count)"
	
	$pathTooLong = $ErrorArray | % Exception | % GetType | ? FullName -eq "System.IO.PathTooLongException" | Measure-Object -Line | Select-Object -ExpandProperty Lines
	Write-Host -ForegroundColor Yellow "`tPath Too Long Errors: $pathTooLong"
	
	$unauthorisedAccess = $ErrorArray | % Exception | ? InnerException | % InnerException | % GetType | ? FullName -eq "System.UnauthorizedAccessException" | Measure-Object -Line | Select-Object -ExpandProperty Lines
	$unauthorisedAccess += $ErrorArray | % Exception | % GetType | ? FullName -eq "System.UnauthorizedAccessException" | Measure-Object -Line | Select-Object -ExpandProperty Lines
	Write-Host -ForegroundColor Yellow "`tUnauthorized Access Errors: $unauthorisedAccess"
	
	$openingFileIo = $ErrorArray | % Exception | ? InnerException | % InnerException | % GetType | ? FullName -eq "System.IO.IOException" | Measure-Object -Line | Select-Object -ExpandProperty Lines
	Write-Host -ForegroundColor Yellow "`tFile IO Errors: $openingFileIo"
	
	$otherErrors = $ErrorArray.Count - $pathTooLong - $unauthorisedAccess - $openingFileIo
	Write-Host -ForegroundColor Yellow "`tOther Errors: $otherErrors"
}