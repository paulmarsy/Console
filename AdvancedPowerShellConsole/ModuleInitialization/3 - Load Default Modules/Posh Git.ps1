# GitHub Windows - http://windows.github.com/
& (Join-Path $env:LOCALAPPDATA "GitHub\shell.ps1") -SkipSSHSetup
Import-Module posh-git -Global
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet

$eventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action {
    Stop-SshAgent
}
$ExecutionContext.SessionState.Module.OnRemove = {
	$eventJob | Stop-Job -PassThru | Remove-Job
}.GetNewClosure()

$gitConfigFileLocation = Join-Path $ProfileConfig.General.PowerShellAppSettingsFolder "Gitconfig.config"
function SetGitConfig {
	param(
		$Name,
        $Value
    )

    & git.exe config --file "$gitConfigFileLocation" $Name $Value
}

SetGitConfig "user.name" $ProfileConfig.Git.Name
SetGitConfig "user.email" $ProfileConfig.Git.Email
SetGitConfig "core.ignorecase" "true"
SetGitConfig "core.autocrlf" "true" 
SetGitConfig "core.editor" "'$(Join-Path $InstallPath "Third Party\Sublime Text\sublime_text.exe")' -w"
SetGitConfig "diff.renames" "true"
SetGitConfig "diff.tool" "bc4"
SetGitConfig "merge.tool" "bc3"
SetGitConfig "pager.log" "false"


# Stop pull requests from being fetched
& git.exe config --system --unset-all remote.origin.fetch .*refs\/pull\/\*.*:.*\/origin\/pr\/\*.*