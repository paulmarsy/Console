function Get-Weight {
    param(
        [Parameter(Mandatory=$true, Position=1)][decimal[]]$OriginalWeights,
        [Parameter(Mandatory=$true, Position=2)][decimal]$CurrentWeight
    ) 
    
    $original = $OriginalWeights | Measure-Object -Sum | % Sum
    
    Write-Host -ForegroundColor DarkGreen ("Original & New Weight: {0}/{1}" -f $original, $CurrentWeight)
    Write-Host -ForegroundColor Green ("Current Weight: {0}" -f ([Math]::Round(($CurrentWeight - $original), 2)))
}