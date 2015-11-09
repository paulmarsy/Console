$InstallPath = Resolve-Path -Path (Join-Path $PSScriptRoot "..\") | % Path

$UserFolder = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Console"
$AppSettingsFolder = Join-Path $UserFolder "App Settings"
$UserScriptsFolder = Join-Path $UserFolder "User Scripts"

$Constants = @{
	InstallPath = $InstallPath
	HookFiles = @{
		PowerShell = $PROFILE.CurrentUserAllHosts
		CommandPrompt = (Join-Path $InstallPath "Custom Consoles\CommandPrompt\Hook.bat")
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
		ConEmuC = (Join-Path $InstallPath "Libraries\ConEmu\ConEmu\ConEmuC64.exe")
		Atom = (Join-Path $InstallPath "Libraries\Atom\App\atom.exe")
		VisualStudioCode = (Join-Path $InstallPath "Libraries\Visual Studio Code\App\Code.exe")
		Hstart = (Join-Path $InstallPath "Libraries\PATH Extensions\Hstart\hstart64.exe")
		ConsoleGitHubSyncer = (Join-Path $InstallPath "Libraries\Custom Helper Apps\ConsoleGitHubSyncer\ConsoleGitHubSyncer.exe")
	}
	GitInstallPath = (Join-Path ${Env:ProgramFiles} "Git")
	MutexGuid = "edb1fbff-b83d-4d5b-9a03-cc535ee29155"
}

& (Join-Path $InstallPath "Libraries\Misc\IsAdmin.exe") -q
$Constants.IsAdmin = $LASTEXITCODE

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
