Write-InstallMessage -EnterNewScope "Installing Windows Features...."

function Dism-Wrapper {
	param($FeatureName)
	Invoke-InstallStep "Installing $FeatureName...." {
		$output = Dism /Online /Enable-Feature /FeatureName:$FeatureName
		if ($LASTEXITCODE -ne 0) {
			 Write-InstallMessage "DISM Error: $output"
		}	
	}
}

Dism-Wrapper TelnetClient

Exit-Scope