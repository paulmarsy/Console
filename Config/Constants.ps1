$InstallPath = Resolve-Path -Path (Join-Path $PSScriptRoot "..\") | % Path

$UserFolder = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Console"
$AppSettingsFolder = Join-Path $UserFolder "App Settings"
$UserScriptsFolder = Join-Path $UserFolder "User Scripts"

$Constants = @{
	InstallPath = $InstallPath
	HookFiles = @{
		PowerShell = $PROFILE.CurrentUserAllHosts
		CommandPrompt = (Join-Path $InstallPath "Custom Consoles\CommandPrompt\Init.bat")
	}
	UserFolders = @{
		Root = $UserFolder
		AppSettingsFolder = $AppSettingsFolder
		AppSettingsFunctionsFolder = (Join-Path $AppSettingsFolder "Functions")
		UserScriptsFolder = $UserScriptsFolder
		UserScriptsIncludeFile = (Join-Path $UserScriptsFolder "include.ps1")
		UserScriptsAutoFolder = (Join-Path $UserScriptsFolder "Auto Import")
		TempFolder = (Join-Path $UserFolder "Temp")
	}
	Version = @{
		CurrentFile = (Join-Path $InstallPath "Version.semver")
		InstalledFile = (Join-Path $AppSettingsFolder "Version.semver")
	}
	Executables = @{
		ConEmu = (Join-Path $InstallPath "Libraries\ConEmu\ConEmu64.exe")
		SublimeText = (Join-Path $InstallPath "Libraries\Sublime Text\sublime_text.exe")
		Hstart = (Join-Path $InstallPath "Libraries\Binaries\Hstart\hstart64.exe")
		ConsoleGitHubSyncer = (Join-Path $InstallPath "Libraries\ConsoleGitHubSyncer\ConsoleGitHubSyncer.exe")
	}
	GitInstallPath = (Join-Path ${Env:ProgramFiles(x86)} "Git")
}

$version = $Constants.Version
$Constants.Version.Update = {
	$version.CurrentVersion = Get-Content -Path $version.CurrentFile
	if (Test-Path $version.InstalledFile) {
		$version.InstalledVersion = Get-Content -Path $version.InstalledFile
	} else {
		$version.InstalledVersion = "Not Installed"
	}
	if ($version.InstalledVersion -eq $version.CurrentVersion) {
		$version.CurrentVersionInstalled = $true
	} else {
		$version.CurrentVersionInstalled = $false
	}
}.GetNewClosure()
$Constants.Version.Update.Invoke()

if ([System.Environment]::Is64BitProcess) {
	$Constants.ProcessArchitecture = "x64" 
} else { 
	$Constants.ProcessArchitecture = "x86" 
}

return $Constants
