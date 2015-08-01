function Update-PowerShellConsoleVersion {
    [CmdletBinding(DefaultParameterSetName="Patch")]
    param(
        [Parameter(ParameterSetName="Major", Mandatory=$false)][switch]$Major,
        [Parameter(ParameterSetName="Minor", Mandatory=$false)][switch]$Minor,
        [Parameter(ParameterSetName="Patch", Mandatory=$false)][switch]$Patch,
        [Parameter(Mandatory=$false)][switch]$Quiet
    )
    
    $versionFilePath = Join-Path $ProfileConfig.Module.InstallPath "Version.semver"
    
    if (-not (Test-Path $versionFilePath)) {
        throw "Version file not found: $versionFilePath"
    }
    
    $rawOldVersion = Get-Content $versionFilePath -Encoding UTF8 -Head 1
    
    if (-not $Quiet) {
        Write-Host
        Write-Host -ForegroundColor Yellow ("Version read from file: {0}" -f $rawOldVersion)    
        Write-Host
    }
    
    $oldVersion = $rawOldVersion |
                    Split-String -Separator '.' -RemoveEmptyStrings -Count 3 |
                    % { [System.UInt16]::Parse($_) }
    
    switch ($oldVersion.Length) {
        2 { $oldVersion = @($oldVersion[0], $oldVersion[1], 0) }
        1 { $oldVersion = @($oldVersion[0], 0, 0) }
    }
    
    if (-not $Quiet) { Write-Host -ForegroundColor Magenta ("Old version: {0}" -f [string]::Join('.', $oldVersion)) }
    
    switch ($PsCmdlet.ParameterSetName) {
        "Major" { $newVersion = @(($oldVersion[0] + 1), 0, 0) }
        "Minor" { $newVersion = @($oldVersion[0], ($oldVersion[1] + 1), 0) }
        "Patch" { $newVersion = @($oldVersion[0], $oldVersion[1],  ($oldVersion[2] + 1)) }
    }
    
    if (-not $Quiet) {
        Write-Host -ForegroundColor Green ("New version: {0}" -f [string]::Join('.', $newVersion))    
        Write-Host
        Write-Host -ForegroundColor DarkGreen "Updating version file... " -NoNewline
    }
    
    Set-Content -Path $versionFilePath -Value ([string]::Join('.', $newVersion)) -NoNewline -Encoding UTF8
    
    if (-not $Quiet) { Write-Host -ForegroundColor DarkGreen "Done." }
}