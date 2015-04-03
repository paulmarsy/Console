function Optimize-PowerShellConsoleFiles {
    try {
        Push-Location $ProfileConfig.Module.InstallPath
        $librariesPath = Join-Path $ProfileConfig.Module.InstallPath "Libraries"
        
        Write-Host -ForegroundColor Green "Removing excess Atom Files..."
        & (Join-Path $librariesPath "Atom\Remove Excess Files.ps1") -NonInteractive
        
        Write-Host -ForegroundColor Green "Removing excess ConEmu Files..."
        & (Join-Path $librariesPath "ConEmu\Remove Excess Files.ps1") -NonInteractive
        
        Write-Host -ForegroundColor Green "Done..."
    }
    finally {
        Pop-Location
    }
}