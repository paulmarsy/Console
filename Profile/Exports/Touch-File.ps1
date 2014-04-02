Set-Alias touch Set-File
function Set-File
{
    param (
        [Parameter(Mandatory=$true)]$path,
        $time = (Get-Date)
    )

    if (-not (Test-Path $path)) {
        Set-Content -LiteralPath $path -Value $null
    }
    
    Set-FileTime -LiteralPath $path -Accessed -Modified -Time $time -Force
}

@{Function = "Set-File"; Alias = "touch"}