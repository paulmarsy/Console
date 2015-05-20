param([switch]$NonInteractive)

Get-ChildItem -Path $PSScriptRoot -Recurse -Include @("spec") -Directory | `
    Sort-Object -Descending -Property FullName | `
    Select-Object -Unique | `
    % { Write-Host "Removing $($_.FullName.Replace($PSScriptRoot, $null))"; $_ } | `
    Remove-Item -Force -Recurse

if (-not $NonInteractive) {
    Write-Host
    Write-Host -NoNewLine "Press any key to continue . . . "
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    Write-Host
}