param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Open-FarManager -InConEmuPane

Start-Process -FilePath $Env:ComSpec -ArgumentList @("-new_console:nbs20V:t:`"Command`"")