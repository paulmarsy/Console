param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 1 }

Import-Module Pscx -Global -ArgumentList @{
    TextEditor = $PowerShellConsoleConstants.Executables.SublimeText
    CD_EchoNewLocation = $false
}