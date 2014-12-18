param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Get-ChildItem -Path (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Format Data") -File -Filter *.format.ps1xml | % {
	Update-FormatData -PrependPath $_.FullName
}