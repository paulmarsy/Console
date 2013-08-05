param($InstallPath)

$profileSettingsFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts -Parent) "ProfileSettings.xml"
if (Test-Path $profileSettingsFile) {
    $ProfileSettings = Import-Clixml $profileSettingsFile
}
else {
    $ProfileSettings = @{
        Git = @{
            Name   = "Name"
            Email  = "email@example.com"
        }
    }
}

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Export-ProfileConfig
}

Get-ChildItem (Join-Path $PSScriptRoot "Configure") -Include *.ps1 -Recurse | Sort-Object Name | % { . $_.FullName -InstallPath $InstallPath -ProfileSettings $ProfileSettings }
Get-ChildItem (Join-Path $PSScriptRoot "ExportedModuleMembers") -Include *.ps1 -Recurse | Sort-Object Name | % { . $_.FullName -InstallPath $InstallPath -ProfileSettings $ProfileSettings }

$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
    Write-Host "Loading include file $includeFile..."
    . $includeFile -ProfileSettings $ProfileSettings
}

Export-ModuleMember -Function *-* -Alias * -Cmdlet *-* -Variable ProfileSettings