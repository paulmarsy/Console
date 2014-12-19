New-Variable -Scope Global -Name MessageScope -Value 0
New-Variable -Scope Global -Name PowerShellConsoleConstants -Value (& (Resolve-Path (Join-Path $PSScriptRoot '..\Constants.ps1')))

Get-ChildItem (Join-Path $PSScriptRoot "Helpers") -Filter *.ps1 | % { . $_.FullName }
. (Join-Path $PowerShellConsoleConstants.InstallPath "PowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $PowerShellConsoleConstants.InstallPath "PowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")