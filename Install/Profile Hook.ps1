param($InstallPath)

"Hooking the profile module into the PowerShell profile..."
$profileFile = $PROFILE.CurrentUserAllHosts
$profileFolder = Split-Path $profileFile -Parent

if (Test-Path $profileFolder) {
	Remove-Item $profileFolder -Force -Recurse
}

New-Item $profileFolder -Type Directory -Force | Out-Null
New-Item $profileFile -Type File -Force | Out-Null

Add-Content $profileFile "function Reset-Profile { Remove-Module Profile -ErrorAction SilentlyContinue; Import-Module ""$InstallPath\Modules\Profile\Profile.psd1"" -ArgumentList ""$InstallPath"" -Force -DisableNameChecking }; Reset-Profile"

(Get-Item $profileFolder).Attributes = 'Hidden'