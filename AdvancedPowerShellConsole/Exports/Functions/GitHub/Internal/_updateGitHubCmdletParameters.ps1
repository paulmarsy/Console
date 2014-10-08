function _updateGitHubCmdletParameters {
    _enterConsoleWorkingDirectory {
        # Update the cmdlet's ValidateSet's with local branches
        $localBranchNames =  & git branch | % { $_.Remove(0, 2) }
        if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
        function updateGitHubCmdletValidateSetParameters {
            param($CmdletName, $Parameters)

            $ValidValuesField = [System.Management.Automation.ValidateSetAttribute].GetField("validValues", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance)

            Get-Command -Name $CmdletName | % { $_.Parameters.Values } | ? { $Parameters -contains $_.Name } | % { $_.Attributes } | ? { $_ -is [System.Management.Automation.ValidateSetAttribute] } | % {
                $ValidValuesField.SetValue($_, ([string[]]$localBranchNames))
            }
        }

        updateGitHubCmdletValidateSetParameters "Publish-ConsoleBranch" @("ParentBranchName", "ChildBranchName")
        updateGitHubCmdletValidateSetParameters "Switch-ConsoleBranch" @("BranchName", "ParentBranchName")
        updateGitHubCmdletValidateSetParameters "Merge-ConsoleBranch" @("SourceBranchName", "DestinationBranchName")
	}
}