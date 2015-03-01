$InstallPath = Get-Item -Path Env:\CustomConsolesInstallPath | % Value

. (Join-Path $InstallPath "Config\Core-Functionality.ps1") -InstallPath $InstallPath

$ModuleInitLevel = & (Join-Path $PSScriptRoot "Module Init Level.ps1")

. (Join-Path $PSScriptRoot "Export-Module.ps1")

New-Variable -Name OnIdleScriptBlockCollection -Scope Global -Value ({@()}.Invoke()) -Force