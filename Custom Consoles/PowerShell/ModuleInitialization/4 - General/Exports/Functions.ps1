param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $true}) }

Get-ChildItem (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Functions") -Filter "*.ps1" -Recurse -File |
	Sort-Object -Property FullName |
	% {
		$functionName = $_.BaseName
		try {
			. $_.FullName
			if (-not $functionName.StartsWith("_") -and ($_.PSParentPath | Split-Path -Leaf) -ne "Internal") {
				Export-ModuleMember -Function $functionName
			}
		}
		catch {
			throw ("Function '{0}' could not be loaded:`n{1}" -f $functionName, $_)
		}
	}