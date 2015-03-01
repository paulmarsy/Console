param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $true}) }

Get-ChildItem (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Functions") -Filter "*.ps1" -Recurse -File |
	Sort-Object -Property FullName |
	% {
		. $_.FullName
		if (-not $_.PSChildName.StartsWith("_") -and ($_.PSParentPath | Split-Path -Leaf) -ne "Internal") {
			Export-ModuleMember -Function $_.BaseName
		}
	}