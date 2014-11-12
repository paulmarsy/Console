# Update PATH to reference 'Binaries' directory and subdirectories
$Path = @(
	$Env:PATH
	(Join-Path $ConsoleRoot "Libraries\Binaries")
	(Get-ChildItem -Path (Join-Path $ConsoleRoot "Libraries\Binaries") | ? PSIsContainer | Select-Object -ExpandProperty FullName) 
) -Join ";"

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)