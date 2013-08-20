Set-Alias sudo Do-Superuser
function Do-Superuser
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromRemainingArguments=$true)]
        $command
    )

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "powershell.exe"
    $pinfo.Arguments = "-NoLogo -NoProfile -NonInteractive -Command ""$command"""
    $pinfo.Verb = "RunAs"
    $pinfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $pinfo.WorkingDirectory = $pwd

    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    Write-Output $p.StandardOutput.ReadToEnd()
    $standardError = $p.StandardError.ReadToEnd()
    if ($standardError) {
        Write-Error $standardError
    }
    $LASTEXITCODE = $p.ExitCode
}   