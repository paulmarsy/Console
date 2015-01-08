param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Export-Module Pscx -ArgumentList @{
    TextEditor = "`"$($PowerShellConsoleConstants.Executables.SublimeTextLauncher)`""
    CD_EchoNewLocation = $false
}