(Get-ChildItem -Path $PSScriptRoot -Recurse -Include @("plugins", "Logs", "Addons", "clink", "DosBox", "Far*")) + `
(Get-ChildItem -Path $PSScriptRoot -Recurse -Exclude @("*.exe", "*.dll", "*.ps1", "ConEmu", "ConEmu.xml", "License.txt")) | `
Sort-Object -Descending -Property FullName | `
Select-Object -Unique | `
% { Write-Host "Removing $($_.FullName.Replace($PSScriptRoot, $null))"; $_ } | `
Remove-Item -Force -Recurse