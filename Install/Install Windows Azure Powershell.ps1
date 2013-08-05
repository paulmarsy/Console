param($InstallPath)

"Installing Windows Azure PowerShell..."
$executablesPath = Join-Path $InstallPath "Install\Executables"
$installerPath = (Get-ChildItem -Path $executablesPath -Filter windowsazure-powershell.*.msi).FullName
msiexec /qb /i $installerPath