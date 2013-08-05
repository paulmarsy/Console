param($InstallPath)

"Installing GitHub Windows..."
$executablesPath = Join-Path $InstallPath "Install\Executables\GitHubSetup.exe"
& $executablesPath /help


<#      }.Add("set-up-ssh", "Setup SSH Keys", (Action<string>) (x => handler.SetUpSSHKeys(true))).Add("credentials=", "Credential caching api for use with Git", new Action<string>(handler.HandleHttpsCreds)).Add("install", "Install the url protocol into the registry", (Action<string>) (x => handler.InstallUrlProtocol())).Add("clean-cache", "Clean all locally cached data", (Action<string>) (x => handler.DeleteCache())).Add("reset", "Reset all application settings and clear all caches", (Action<string>) (x => handler.ResetAllSettings())).Add("uninstall", "Uninstall the url protocol from the registry", (Action<string>) (x => handler.UninstallUrlProtocol())).Add("u=|url=", "Clone the specified GitHub repository", new Action<string>(handler.ParseCloneUrl)).Add("config:", "Set or show configuration values", new Action<string>(handler.Config));

"install", "Install the url protocol into the registry"
"clean-cache", "Clean all locally cached data"
"reset", "Reset all application settings and clear all caches"
#>