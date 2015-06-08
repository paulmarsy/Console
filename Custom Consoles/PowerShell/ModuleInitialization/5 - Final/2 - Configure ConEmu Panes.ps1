param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Open-FarManager -InConEmuPane
Open-CommandPrompt -InConEmuPane