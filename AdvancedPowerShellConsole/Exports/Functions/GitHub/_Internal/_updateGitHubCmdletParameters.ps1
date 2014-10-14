function _updateGitHubCmdletParameters {
    _workOnConsoleWorkingDirectory {
        # Update the cmdlet's ValidateSet's with local branches
        $localBranchNames =  & git branch -l | % { $_.Remove(0, 2) }
        $remoteBranchNames =  & git branch -l | % { $_.Remove(0, 2) } | ? { -not $_.StartsWith("origin/HEAD") -and $_ -notlike "origin/pr/*"}
        $branchNames = $localBranchNames + $remoteBranchNames
        if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
        
        function updateGitHubCmdletValidateSetParameters {
            param($CmdletName, $Parameters)

            $ValidValuesField = [System.Management.Automation.ValidateSetAttribute].GetField("validValues", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance)

            Get-Command -Name $CmdletName | % { $_.Parameters.Values } | ? { $Parameters -contains $_.Name } | % { $_.Attributes } | ? { $_ -is [System.Management.Automation.ValidateSetAttribute] } | % {
                $ValidValuesField.SetValue($_, ([string[]]$branchNames))
            }
        }

        updateGitHubCmdletValidateSetParameters "Publish-ConsoleBranch" @("ParentBranchName", "ChildBranchName")
        updateGitHubCmdletValidateSetParameters "Switch-ConsoleBranch" @("BranchName", "ParentBranchName")
        updateGitHubCmdletValidateSetParameters "Merge-ConsoleBranch" @("SourceBranchName", "DestinationBranchName")
        updateGitHubCmdletValidateSetParameters "Remove-ConsoleBranch" @("BranchName")
	}
}