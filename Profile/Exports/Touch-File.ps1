Set-Alias touch Set-File
function Set-File
{
    param (
        [Parameter(Mandatory=$true)]$path
    )

    if (Test-Path $path) {
        Set-FileTime -LiteralPath $path -Accessed -Modified
    }
    else {
        Set-Content -LiteralPath $path -Value $null
    }
}

@{Function = "Set-File"; Alias = "touch"}