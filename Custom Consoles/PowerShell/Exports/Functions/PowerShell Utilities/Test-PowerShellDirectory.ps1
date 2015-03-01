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
    if (-not $Quiet) {
        Write-Host -ForegroundColor Yellow "Testing PowerShell script file syntax..."
    }
    Get-ChildItem $Directory -File -Recurse -Include @("*.ps1", "*.psd1", "*.psm1") -Exclude $Exclude |
        % FullName |
        Test-PowerShellScriptSyntax -BaseDirectory $Directory |
        % {
            $failedTests++
            if ($null -ne $_.Start -and $null -ne $_.End) {
                if ($_.Start -eq $_.End) {
                    $fileDescription = "{0} {1}:" -f $_.File, $_.Start
                } else {
                    $fileDescription = "{0} {1}-{2}:" -f $_.File, $_.Start, $_.End
                }
            } else {
                $fileDescription = "{0}:" -f $_.File
            }
            if ($IncludeContext -and -not ([string]::IsNullOrWhiteSpace($_.Content))) {
                $errorMessage = "{0} ({1})" -f $_.Error, $_.Content
            } else {
                $errorMessage = $_.Error
            }

            Write-Host ("{0} {1}" -f $fileDescription, $errorMessage)
        }

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
