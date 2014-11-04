New-Variable -Scope Global -Name MessageScope -Value 0
New-Variable -Scope Global -Name PowerShellConsoleContstants -Value (& (Resolve-Path (Join-Path $PSScriptRoot '..\..\Common\Constants.ps1')))

Get-ChildItem ".\Install Helpers" -Filter *.ps1 | % { . $_.FullName }
. (Join-Path $PowerShellConsoleContstants.InstallPath "PowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $PowerShellConsoleContstants.InstallPath "PowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")