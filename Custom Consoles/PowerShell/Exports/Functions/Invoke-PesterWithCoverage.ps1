function Invoke-PesterWithCoverage {
    param(
        $Path = $PWD
    )
    
    try {
        Push-Location $Path
        Invoke-Pester -Strict -CodeCoverage (Get-ChildItem -File -Recurse -Include "*.ps1" -Exclude "*.Tests.ps1")
    }
    finally {
        Pop-Location
    }
}