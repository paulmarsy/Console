$InstallPath = Get-Item -Path Env:\CustomConsolesInstallPath | % Value

$ModuleInitLevel = & (Join-Path $PSScriptRoot "Module Init Level.ps1")

. (Join-Path $PSScriptRoot "Export-Module.ps1")

New-Variable -Name OnIdleScriptBlockCollection -Scope Global -Value ({@()}.Invoke()) -Force