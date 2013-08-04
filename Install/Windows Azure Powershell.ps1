param($InstallPath)

"Installing Windows Azure PowerShell..."
$installerName = (Get-Item windowsazure-powershell.*.msi | Sort-Object -Descending | Select-Object -First 1).Name
msiexec /qb /i $InstallPath\Install\$installerName