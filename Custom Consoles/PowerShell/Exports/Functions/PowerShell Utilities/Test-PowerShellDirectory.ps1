function Test-PowerShellDirectory {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path -Path $_})]
        $Directory,
        [switch]$IncludeContext
    )

    Get-ChildItem $Directory -File -Recurse -Include @("*.ps1", "*.psd1", "*.psm1") |
        % FullName |
        Test-PowerShellFile -BaseDirectory $Directory |
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
}
