param($InstallPath)

$profileConfigFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts) "ProfileConfig.xml"

Get-ChildItem $PSScriptRoot | % { . $_.FullName }

$ProfileConfig = Initialize-ProfileConfig

Export-ModuleMember -Function * -Alias * -Cmdlet * -Variable ProfileConfig