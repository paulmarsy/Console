function Start-PowerShell {
    [CmdletBinding()]
    param(
        [ValidateSet("Native", "32bit", "64bit")]$Bitness = "Native",
        [Parameter(ValueFromRemainingArguments=$true)]$Switches
    )

    $64bitOs = [System.Environment]::Is64BitOperatingSystem
    $32bitOs = -not $64bitOs
    $64bitProcess = [System.Environment]::Is64BitProcess
    $32bitProcess = -not $64bitProcess

    $sysFolder = switch ($Bitness) {
        "Native" {
            if ($64bitOs -and $64bitProcess) { "System32"; break }
            if ($64bitOs -and $32bitProcess) { "Sysnative"; break }
            if ($32bitOs) { "System32"; break }
        }
        "32bit" {
            if ($64bitOs -and $64bitProcess) { "SysWOW64"; break }
            if ($64bitOs -and $32bitProcess) { "System32"; break }
            if ($32bitOs) { "System32"; break }
        "64bit" {
            if ($64bitOs -and $64bitProcess) { "System32"; break }
            if ($64bitOs -and $32bitProcess) { "Sysnative"; break }
            if ($32bitOs) { Write-Host -ForegroundColor Red "Can't Start 64bit PowerShell on a 32bit Operating System"; return }            
        }
    }

    & "$env:windir\$sysFolder\WindowsPowerShell\v1.0\powershell.exe" $Switches
}                   