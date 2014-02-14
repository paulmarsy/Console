
function Find-FileOrFolder {
    [CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$name,
		$path = $pwd
    )

	$maxFileSizeToSearchInBytes = 1024*1024 # 1mb
	
	Write-Host "Finding '$pattern' in $path...`n" -ForegroundColor White
	Get-ChildItem -Path $path -Recurse | 
		? { $_.PSIsContainer -eq $false -and ($includeLargeFiles -or $_.Length -le $maxFileSizeToSearchInBytes) } | 
}
@{Function = "Find-F"}