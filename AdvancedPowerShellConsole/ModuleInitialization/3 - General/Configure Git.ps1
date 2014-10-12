function UpdateGit {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$config
    )
    & git config $config user.name $ProfileConfig.Git.Name
    & git config $config user.email $ProfileConfig.Git.Email
    & git config $config core.ignorecase $True
    & git config $config core.autocrlf $True 
    & git config $config core.editor "'$(Join-Path $InstallPath "Third Party\Sublime Text\sublime_text.exe")' -w"
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

$gitFileLocation = Join-Path $ProfileConfig.General.ProfileFolder "gitconfig"
if (-not (Test-Path $gitFileLocation)) {
    New-Item $gitFileLocation -Type File -Force | Out-Null
} 

UpdateGit --file "$gitFileLocation"