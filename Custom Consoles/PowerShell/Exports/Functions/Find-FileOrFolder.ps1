function Find-FileOrFolder {
    [CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$Name,
		$Path = $PWD,
		[switch]$PartialName
    )

	if ($PartialName -or ([string]::IsNullOrWhiteSpace([System.IO.Path]::GetExtension($Name)))) { $Name = "*$($Name)*" }

	$searchErrors = @()

	Get-ChildItem -Path $path -Recurse -Filter $name -ErrorAction SilentlyContinue -ErrorVariable +searchErrors | % { Resolve-Path -Relative $_.FullName } | Out-Host

	Write-Host
	_Write-FileSystemAccessErrors -ErrorArray $searchErrors
		
}