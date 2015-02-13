Invoke-InstallStep "Creating Atom Config Directory Environment Variable" {
    $customAtomConfigDirectory = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Atom\Config"
    [System.Environment]::SetEnvironmentVariable("ATOM_HOME", $customAtomConfigDirectory, [System.EnvironmentVariableTarget]::User)
}
