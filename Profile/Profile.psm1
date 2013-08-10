param($InstallPath)

Get-ChildItem "$PSScriptRoot\", "$PSScriptRoot\Configure", "$PSScriptRoot\ExportedModuleMembers" -Filter *.ps1 | Sort-Object DirectoryName, Name | % { . $_.FullName -InstallPath $InstallPath -ConsoleConfig $Global:ConsoleConfig }

$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
    Write-Host "Loading include file $includeFile..."
    . $includeFile -ConsoleConfig $Global:ConsoleConfig
}

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Export-ConsoleConfig
}

Export-ModuleMember -Function *-* -Alias * -Cmdlet *-* -Variable ConsoleConfig