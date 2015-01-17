Invoke-InstallStep "Creating Atom Config directory junction" {
    $defaultAtomConfigDirectory = Join-Path $Env:USERPROFILE ".atom"
    $customAtomConfigDirectory = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Atom\Config"

    ConvertTo-DirectoryJunction -JunctionPath $defaultAtomConfigDirectory -TargetPath $customAtomConfigDirectory
}
