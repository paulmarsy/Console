# PSReadline - https://github.com/lzybkr/PSReadLine
if ($Host.Name -eq 'ConsoleHost') {
	Import-Module PSReadline -Global
	Set-PSReadlineKeyHandler -Key Ctrl+C -Function CopyOrCancelLine
	Set-PSReadlineKeyHandler -Key Ctrl+Shift+Home -Function ScrollDisplayTop
	Set-PSReadlineKeyHandler -Key Ctrl+Shift+End -Function ScrollDisplayToCursor
}