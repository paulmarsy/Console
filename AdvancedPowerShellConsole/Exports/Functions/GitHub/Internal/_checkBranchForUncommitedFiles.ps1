function _checkBranchForUncommitedFiles {
    if (_getNumberOfUncommitedChanges -gt 0) {
        $autoCheckin = Show-ConfirmationPrompt -Caption "You have uncommited changes in the current branch" -Message "Do you want to check them in now?"
        if ($autoCheckin) {
            $commitMessage = Read-Host -Prompt "Commit message"
            if ([string]::IsNullOrWhiteSpace($commitMessage)) {
                Write-Host -ForegroundColor Red "ERROR: Commit message cannot be empty"
                return $false
            }
            Sync-Console -CommitMessage $commitMessage -DontSyncWithGitHub
            if (_getNumberOfUncommitedChanges -gt 0) {
                Write-Host -ForegroundColor Red "ERROR: There are still uncommited changes in the workspace, please manually resolve before continuing"
                return $false
            }
        } else {
            Write-Host -ForegroundColor Red "ERROR: Cannot continue while there are uncommited changes"
            return $false
        }
    } else {
        return $true
    }
}