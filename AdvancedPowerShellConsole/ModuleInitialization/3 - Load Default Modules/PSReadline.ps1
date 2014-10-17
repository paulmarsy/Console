# PSReadline - https://github.com/lzybkr/PSReadLine
if ($Host.Name -eq 'ConsoleHost') {
	Import-Module PSReadline -Global
	Set-PSReadlineOption -ShowToolTips
	Set-PSReadlineOption -HistorySavePath (Join-Path $ProfileConfig.General.PowerShellAppSettingsFolder "PSReadline-history.txt")
	Set-PSReadlineOption -MaximumHistoryCount 100
	Set-PSReadlineKeyHandler -Key Ctrl+C -Function CopyOrCancelLine
	Set-PSReadlineKeyHandler -Key Ctrl+Shift+Home -Function ScrollDisplayTop
	Set-PSReadlineKeyHandler -Key Ctrl+Shift+End -Function ScrollDisplayToCursor
}