param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Import-Module Pscx -Global -ArgumentList @{
    TextEditor = "`"$($PowerShellConsoleConstants.Executables.SublimeText)`""
    CD_EchoNewLocation = $false
}