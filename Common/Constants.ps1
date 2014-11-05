$ConsoleRoot = Resolve-Path (Join-Path $PSScriptRoot "..\") | % Path

$UserFolder = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Console"
$AppSettingsFolder = Join-Path $UserFolder "App Settings"
$UserScriptsFolder = Join-Path $UserFolder "User Scripts"

$Constants = @{
	InstallPath = $ConsoleRoot
	HookFiles = @{
		PowerShell = $PROFILE.CurrentUserAllHosts
		CommandPrompt = (Join-Path $ConsoleRoot "CommandPromptConsole\Init.bat")
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
		CurrentFile = (Join-Path $ConsoleRoot "Install\Version.semver")
		InstalledFile = (Join-Path $AppSettingsFolder "Version.semver")
	}
	Executables = @{
		ConEmu = (Join-Path $ConsoleRoot "Third Party\ConEmu\ConEmu64.exe")
		SublimeText = (Join-Path $ConsoleRoot "Third Party\Sublime Text\sublime_text.exe")
	}
}

$Constants.Version.CurrentVersion = Get-Content -Path $Constants.Version.CurrentFile
if (Test-Path $Constants.Version.InstalledFile) {
	$Constants.Version.InstalledVersion = Get-Content -Path $Constants.Version.InstalledFile
} else {
	$Constants.Version.InstalledVersion = "Not Installed"
}
if ($Constants.Version.InstalledVersion -eq $Constants.Version.CurrentVersion) {
	$Constants.Version.CurrentVersionInstalled = $true
} else {
	$Constants.Version.CurrentVersionInstalled = $false
}

if ([System.Environment]::Is64BitProcess) {
	$Constants.ProcessArchitecture = "x64" 
} else { 
	$Constants.ProcessArchitecture = "x86" 
}

return $Constants
