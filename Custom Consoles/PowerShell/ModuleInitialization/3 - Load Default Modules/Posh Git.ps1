param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Export-Module posh-git
$GitPromptSettings.EnableWindowTitle = $null