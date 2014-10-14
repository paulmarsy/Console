function UpdateGit {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$config
    )
    & git config $config user.name $ProfileConfig.Git.Name
    & git config $config user.email $ProfileConfig.Git.Email
    & git config $config core.ignorecase true
    & git config $config core.autocrlf true 
    & git config $config core.editor "'$(Join-Path $InstallPath "Third Party\Sublime Text\sublime_text.exe")' -w"
    & git config $config diff.renames true
    & git config $config diff.tool bc4
    & git config $config merge.tool bc3
    & git config $config --add pager.log false
}

$gitFileLocation = Join-Path $ProfileConfig.General.PowerShellAppSettingsFolder "Gitconfig"

UpdateGit --file "$gitFileLocation"