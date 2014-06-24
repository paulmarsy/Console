Set-Alias touch Set-File
function Set-File
{
    param (
        [Parameter(Mandatory=$true)]$path,
        $content = $null,
        $time = (Get-Date)
    )

    if (-not (Test-Path $path) -or ((Test-Path $path) -and $null -ne $content)) {
        Set-Content -Path $path -Value $content
    }
    
    Set-FileTime -Path $path -Accessed -Modified -Time $time -Force
}

@{Function = "Set-File"; Alias = "touch"}