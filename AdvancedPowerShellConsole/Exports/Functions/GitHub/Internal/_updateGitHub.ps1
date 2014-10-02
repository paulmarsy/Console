function _updateGitHub {
    _enterConsoleWorkingDirectory {
    	$outputPath = [System.IO.Path]::GetTempFileName()
    	Start-Process -FilePath "git.exe" -ArgumentList "remote --verbose update" -WindowStyle Hidden -Wait -RedirectStandardOutput $outputPath
    	$output = Get-Content -Path $outputPath
    	Remove-Item -Path $outputPath

		# Update the cmdlet's ValidateSet's with local branches
		$localBranchNames =  & git branch | % { $_.Remove(0, 2) }
    	function updateGitHubCmdletValidateSetParameters {
    		param($CmdletName, $Parameters)

    		$ValidValuesField = [System.Management.Automation.ValidateSetAttribute].GetField("validValues", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance)

        	Get-Command -Name $CmdletName | % { $_.Parameters.Values } | ? { $Parameters -contains $_.Name } | % { $_.Attributes } | ? { $_ -is [System.Management.Automation.ValidateSetAttribute] } | % {
	            $ValidValuesField.SetValue($_, ([string[]]$localBranchNames))
        	}
        }

        updateGitHubCmdletValidateSetParameters "Merge-ConsoleBranch" @("ParentBranchName", "ChildBranchName")
		updateGitHubCmdletValidateSetParameters "Switch-ConsoleBranch" @("BranchName")

    	return $output
	}
}