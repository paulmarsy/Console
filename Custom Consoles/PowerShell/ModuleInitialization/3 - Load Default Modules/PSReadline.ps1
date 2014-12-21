param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

Export-Module PSReadline
Set-PSReadlineOption -ShowToolTips
Set-PSReadlineOption -HistorySavePath (Join-Path $ProfileConfig.Module.AppSettingsFolder "PSReadline-history.txt")
Set-PSReadlineOption -MaximumHistoryCount 100
Set-PSReadlineKeyHandler -Key Ctrl+C -Function CopyOrCancelLine
Set-PSReadlineKeyHandler -Key Ctrl+Shift+Home -Function ScrollDisplayTop
Set-PSReadlineKeyHandler -Key Ctrl+Shift+End -Function ScrollDisplayToCursor