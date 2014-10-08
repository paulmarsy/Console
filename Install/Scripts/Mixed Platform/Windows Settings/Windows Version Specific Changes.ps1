Write-InstallMessage -EnterNewScope "Installing Windows version specific changes"

$windowsVersion = [System.Environment]::OSVersion.Version

$windowsChangeSet = $null
if ($windowsVersion.Major -eq 6) {
	if ($windowsVersion.Minor -eq 4) {
		$windowsChangeSet = "Windows 10"
	} elseif ($windowsVersion.Minor -in @(1, 2, 3)) {
		$windowsChangeSet = "WIndows 7, 8 & 8.1"
	}
}

if ($null -eq $windowsChangeSet) {
	Write-InstallMessage -Type Info "No version specific for your operating system ($([System.Environment]::OSVersion.VersionString))"
} else {
	Invoke-InstallStep "Installing Windows changes for $windowsChangeSet" { 
		Get-ChildItem -Path "$(Join-Path "Windows Settings\Version Specific Changes" $windowsChangeSet)" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }
	}
}

Exit-Scope