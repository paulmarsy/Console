Set-Alias sudo Do-Superuser
function Do-Superuser
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