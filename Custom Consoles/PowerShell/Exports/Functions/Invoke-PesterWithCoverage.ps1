function Invoke-PesterWithCoverage {
    param(
        $Path = $PWD
    )
    
    Invoke-Pester -Path $Path -CodeCoverage (Get-ChildItem -Path $Path -File -Recurse -Include "*.ps1" -Exclude "*.Tests.ps1" | % FullName)
}