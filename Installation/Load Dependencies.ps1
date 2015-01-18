New-Variable -Scope Global -Name MessageScope -Value 0
New-Variable -Scope Global -Name InsideInstallStep -Value $false

New-Variable -Scope Global -Name PowerShellConsoleConstants -Value (& (Resolve-Path (Join-Path $PSScriptRoot '..\Config\Constants.ps1')))

Get-ChildItem (Join-Path $PSScriptRoot "Helpers") -Filter *.ps1 | % { . $_.FullName }
. (Join-Path $PowerShellConsoleConstants.InstallPath "Custom Consoles\PowerShell\Exports\Functions\ConvertTo-DirectoryJunction.ps1")
. (Join-Path $PowerShellConsoleConstants.InstallPath "Custom Consoles\PowerShell\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $PowerShellConsoleConstants.InstallPath "Custom Consoles\PowerShell\Exports\Aliases\U+003F`&U+003A.ps1")

& (Join-Path $PowerShellConsoleConstants.InstallPath "Custom Consoles\PowerShell\ModuleInitialization\2 - Configure Environment\Configure PATH Extensions.ps1")
