param($InstallPath)

Remove-Item Alias:\su
function su
{
    Start-Process -FilePath "$InstallPath\ConEmu\ConEmu.exe" -ArgumentList "/cmd powershell.exe" -Verb RunAs -WorkingDirectory $pwd
}

function sudo
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $command
    )

    $sudoOutput = [IO.Path]::GetTempFileName()

    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoLogo -NoProfile -NonInteractive -Command ""$command | Export-Clixml $sudoOutput""" -Verb RunAs -WorkingDirectory $pwd -Wait -WindowStyle Hidden
    Import-Clixml $sudoOutput
    
    Remove-Item $sudoOutput
}   