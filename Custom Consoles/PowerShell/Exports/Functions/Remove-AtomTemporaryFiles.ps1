function Remove-AtomTemporaryFiles {
    try {
        Push-Location (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Atom\Config")
        & git.exe ls-files --others --ignored --exclude-standard |
            % { $_.Split('/') | Select-Object -First 1 } |
            Select-Object -Unique |
            Resolve-Path |
            Remove-Item -Recurse -Force
    }
    finally {
        Pop-Location
    }
}