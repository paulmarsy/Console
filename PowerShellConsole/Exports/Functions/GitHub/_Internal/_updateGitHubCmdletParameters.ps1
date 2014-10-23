function _updateGitHubCmdletParameters {
    _workOnConsoleWorkingDirectory {
        $branchNames = (_getLocalBranches) + (_getRemoteBranches)
        
        function updateGitHubCmdletValidateSetParameters {
            param($CmdletName, $Parameters)

            $ValidValuesField = [System.Management.Automation.ValidateSetAttribute].GetField("validValues", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance)

            Get-Command -Name $CmdletName | % Parameters | % Values | ? { $Parameters -contains $_.Name } | % Attributes | ? { $_ -is [System.Management.Automation.ValidateSetAttribute] } | % {
                $ValidValuesField.SetValue($_, ([string[]]$branchNames))
            }
        }

        updateGitHubCmdletValidateSetParameters "Publish-ConsoleBranch" @("ParentBranchName", "ChildBranchName")
        updateGitHubCmdletValidateSetParameters "Switch-ConsoleBranch" @("BranchName", "ParentBranchName")
        updateGitHubCmdletValidateSetParameters "Merge-ConsoleBranch" @("SourceBranchName", "DestinationBranchName")
        updateGitHubCmdletValidateSetParameters "Compare-ConsoleBranches" @("LeftBranchName", "RightBranchName")
        updateGitHubCmdletValidateSetParameters "Remove-ConsoleBranch" @("BranchName")
	}
}