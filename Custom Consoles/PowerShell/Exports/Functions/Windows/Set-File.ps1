function Set-File
{
    param (
        [Parameter(Mandatory=$true)]$Path,
        $Content = $null,
        $Time = (Get-Date)
    )

    if (-not (Test-Path $Path) -or ((Test-Path $Path) -and $null -ne $Content)) {
        Set-Content -Path $Path -Value $Content
    }
    
    Set-FileTime -Path $Path -Accessed -Modified -Time $Time -Force
}