function Test-PowerShellScript {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -Path $_})]
        $File,
        [switch]$IncludeContext,
        [switch]$Quiet,
        [switch]$ReturnResultOnly
    )

    if (-not $Quiet) {
        Write-Host -ForegroundColor Yellow "Testing PowerShell script file syntax..."
    }

    $testResult = $true
    Test-PowerShellScriptSyntax -File $File |
        ? { $_ -eq $false } |
        % { $testResult = $false } | 
        ? { -not $Quiet -and -not $ReturnResultOnly } |
        % {
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
    
    return $testResult
}
