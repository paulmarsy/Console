param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $true}) }

Get-ChildItem (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Aliases") -Filter "*.alias" -File | % {
	$alias = $_.BaseName
	if ($alias.StartsWith("0x")) {
		$alias = [string]::Concat(($alias | % Split '+' | % { [char][int]($_) }))
	}
	$command = Get-Content -Path $_.FullName | Select-Object -First 1
	Set-Alias -Name $alias -Value $command -Force
	Export-ModuleMember -Alias $alias
}
