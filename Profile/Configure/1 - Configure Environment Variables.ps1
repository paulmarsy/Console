# Update PATH to reference 'Binaries' directory and subdirectories
$env:Path += ";" + (Join-Path $InstallPath Binaries) + ";" + ((Get-ChildItem (Join-Path $InstallPath Binaries) | Where {$_.psIsContainer} | Select -expandProperty FullName) -join ";")
$env:Path = $env:Path.Trim(';')

# Update PSModulePath to reference 'Modules' directory
$env:PSModulePath += ";" + (Join-Path $InstallPath Modules)
$env:PSModulePath = $env:PSModulePath.Trim(';')