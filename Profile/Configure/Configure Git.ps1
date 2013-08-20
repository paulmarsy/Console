param($InstallPath)

function UpdateGit {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$config
    )
    & git config $config user.name $ConsoleConfig.Git.Name
    & git config $config user.email $ConsoleConfig.Git.Email
    & git config $config core.ignorecase $True
    & git config $config core.autocrlf $True 
    & git config $config core.editor "'$(Join-Path $InstallPath "Sublime Text\sublime_text.exe")' -w"
    & git config $config diff.renames $True
    & git config $config diff.tool bc4
    & git config $config merge.tool bc3
}

<#
UpdateGit --file "$env:USERPROFILE\.gitconfig"
Is used instead of:
UpdateGit --global

As $env:HOME has been set to D:\Dropbox\
#>

UpdateGit --system
UpdateGit --file "$env:USERPROFILE\.gitconfig"