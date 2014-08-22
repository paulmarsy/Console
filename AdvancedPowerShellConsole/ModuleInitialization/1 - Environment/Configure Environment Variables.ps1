# Update PATH to reference 'Binaries' directory and subdirectories
$env:Path += ";" + (Join-Path $InstallPath "Third Party\Binaries") + ";" + ((Get-ChildItem (Join-Path $InstallPath "Third Party\Binaries") | Where {$_.psIsContainer} | Select -expandProperty FullName) -join ";")
$env:Path = $env:Path.Trim(';')

# Update PSModulePath to reference 'PowerShell Modules' directory
$env:PSModulePath += ";" + (Join-Path $InstallPath "Third Party\PowerShell Modules")
$env:PSModulePath = $env:PSModulePath.Trim(';')