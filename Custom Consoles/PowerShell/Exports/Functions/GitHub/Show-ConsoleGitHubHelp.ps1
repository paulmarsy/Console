function Show-ConsoleGitHubHelp {
	Write-Host -ForegroundColor Green "`t`tPowerShell Console GitHub Commands"
	Get-ChildItem $PSScriptRoot -Filter *.ps1 | Sort-Object FullName | % {
		$FunctionName = $_.BaseName
		return $_
	} | Format-Table -Property @(
			@{Name = "Function Name"; Expression = { $FunctionName }}
		) -AutoSize
}