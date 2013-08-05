function UpdateGit {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$config
    )
    & git config $config user.name $ConsoleConfig.Git.Name
    & git config $config user.email $ConsoleConfig.Git.Email
    & git config $config core.ignorecase $ConsoleConfig.Git.IgnoreCase
    & git config $config diff.renames $ConsoleConfig.Git.DiffRenames
}

UpdateGit --system
UpdateGit --file "$env:USERPROFILE\.gitconfig"

<#

UpdateGit --file "$env:USERPROFILE\.gitconfig"
The above is used instead of:
UpdateGit --global

As $env:HOME has been set to D:\Dropbox\

#>