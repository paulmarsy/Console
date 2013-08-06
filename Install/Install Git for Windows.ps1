param($InstallPath)

"Installing Git for Windows..."
$executablesPath = Join-Path $InstallPath "Install\Executables"
$installerPath = (Get-ChildItem -Path $executablesPath -Filter Git-*.exe).FullName
& $installerPath /SILENT