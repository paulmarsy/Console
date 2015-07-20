function Test-PowerShellDirectory {
    param(
        [ValidateScript({Test-Path -Path $_})]
        $Directory = $PWD.Path,
        $Exclude,
        [switch]$IncludeContext,
        [switch]$Quiet,
        [switch]$ReturnNumberOfProblems
    )

    $failedTests = 0
    Get-ChildItem $Directory -File -Recurse -Include @("*.ps1", "*.psd1", "*.psm1") -Exclude $Exclude |
        % { Test-PowerShellScript -File $_.FullName -IncludeContext:$IncludeContext -Quiet:$Quiet } |
        ? { $_ -eq $false } | 
        % { $failedTests++ }

    if (-not $Quiet) {
        Write-Host -ForegroundColor Yellow "Testing PowerShell module manifest files..."
    }
    Get-ChildItem $Directory -File -Recurse -Include "*.psd1" -Exclude $Exclude |
        % {
            $fileName = $_.Name
            $errorMessages = $null
            $warningMessages = $null
            Test-ModuleManifest -Path $_.FullName -ErrorVariable errorMessages -ErrorAction Ignore -WarningVariable warningMessages -WarningAction Ignore | Out-Null

            # Uniqueness is checked because submodules may have errors/warnings, however those will likely be picked up in a different loop iteration
            $errorMessages | Select-Object -Unique | % {
                $failedTests++
                Write-Host ("{0}: Error - {1}" -f $fileName, $_)
            }
            $warningMessages | Select-Object -Unique | % {
                $failedTests++
                Write-Host ("{0}: Warning - {1}" -f $fileName, $_)
            }
        }
        if ($ReturnNumberOfProblems) { return $failedTests }
}
