function Show-PowerShellConsoleHelp
{
	Write-Host -ForegroundColor Green "`t`tCmdlets"
	$ExecutionContext.SessionState.Module | % ExportedCmdlets | % GetEnumerator | % Value -PipelineVariable Key | `
		Format-Table -Property @(
			@{Name = "Cmdlet Name"; Expression = { $Key }}
			@{Name = "Usage"; Expression = { $_.Definition.Trim() }}
		) -AutoSize

	Write-Host -ForegroundColor Green "`t`tFunctions"
	$ExecutionContext.SessionState.Module | % ExportedFunctions | % GetEnumerator | % Value -PipelineVariable Key | `
		Format-Table -Property @(
			@{Name = "Function Name"; Expression = { $Key }}
		) -AutoSize

	Write-Host -ForegroundColor Green "`t`tAliases"
	$ExecutionContext.SessionState.Module | % ExportedAliases | % GetEnumerator | % Value -PipelineVariable Key | `
		Format-Table -Property @(
			@{Name = "Alias Name"; Expression = { $Key }}
			@{Name = "Aliased Command"; Expression = { $_.Definition }}
		) -AutoSize
}