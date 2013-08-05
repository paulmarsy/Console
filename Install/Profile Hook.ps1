param($InstallPath)

"Setting up PowerShell Profile Directory..."
$profileFolder = Split-Path $PROFILE.CurrentUserAllHosts -Parent
if (!(Test-Path $profileFolder)) {
    New-Item $profileFolder -Type Directory -Force | Out-Null
}
(Get-Item $profileFolder -Force).Attributes = 'Hidden'

"Hooking up to Profile File..."
$generatedProfileToken = "<# Custom Profile Hook #>"

$PROFILE | Get-Member -MemberType NoteProperty | % { $PROFILE | Select-Object -ExpandProperty $_.Name } | ? { (Test-Path $_) -and ((Get-Content $_ | Select-Object -First 1) -ne $generatedProfileToken) } | % {
    Write-Host -ForegroundColor Red "$_ already exists, backing up to $($_ + ".bak")"
    Move-Item $_ ($_ + ".bak") -Force
}

New-Item $PROFILE.CurrentUserAllHosts -Type File -Force | Out-Null
Add-Content $PROFILE.CurrentUserAllHosts @"
$generatedProfileToken
function Reset-Profile {
    Remove-Module Profile -ErrorAction SilentlyContinue
    `$profileSettingsFile = $(Join-Path $profileFolder "ProfileSettings.xml")
    if (Test-Path `$profileSettingsFile) {
        `$Global:ProfileSettings = Import-Clixml `$profileSettingsFile
    }
    Import-Module "$InstallPath\Modules\Profile\Profile.psd1" -ArgumentList "$InstallPath" -Force -DisableNameChecking
}
Reset-Profile
"@