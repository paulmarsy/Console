function Find-FileOrFolder {
    [CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$name,
		$path = $pwd,
		[switch]$partialName
    )
	
	if ($partialName) { $name = "*$($name)*" }
	Get-ChildItem -Path $path -Recurse -Filter $name | % { Resolve-Path -Relative $_.FullName }
}