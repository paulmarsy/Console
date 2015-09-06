param([switch]$NonInteractive)

Get-ChildItem -Path $PSScriptRoot -Recurse -Include @(
    "`$PLUGINSDIR"
    "[LICENSE].txt"
    "[NSIS].nsi"
    "Uninstall.exe"
    "vcredist_x86.exe"
    "vcredist2008_x86.exe"
    "winpcap-nmap-4.13.exe"
    "COPYING_HIGWIDGETS"
    "InstallOptions.dll"
    ) | `
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