# PSReadline - https://github.com/lzybkr/PSReadLine
if ($host.Name -eq 'ConsoleHost') {
	Import-Module PSReadline -Global
	Set-PSReadlineOption -HistoryNoDuplicates
	Set-PSReadlineKeyHandler -Key Ctrl+C -Function CopyOrCancelLine
	Set-PSReadlineKeyHandler -Key Ctrl+Shift+Home -Function ScrollDisplayTop
	Set-PSReadlineKeyHandler -Key Ctrl+Shift+End -Function ScrollDisplayToCursor
}