param(
    $InstallPath = (Get-Item -Path Env:\CustomConsolesInstallPath | % Value)
)

# Constants
$PowerShellConsoleConstants = & (Join-Path $InstallPath "Config\Constants.ps1")

# Module Initialization
$private:ModuleInitializationRoot = Join-Path $InstallPath "Custom Consoles\PowerShell\ModuleInitialization"
@(
    "2 - Configure Environment\Configure PATH Extensions.ps1"
) | % { & (Join-Path $private:ModuleInitializationRoot $_) }

# Functions
$private:FunctionExportsRoot = Join-Path $InstallPath "Custom Consoles\PowerShell\Exports\Functions"
@(
    "PowerShell Utilities\Set-Constant.ps1"
    "PowerShell Utilities\Test-PowerShellScriptSyntax.ps1"
    "PowerShell Utilities\Test-PowerShellDirectory.ps1"
    "Windows\ConvertTo-DirectoryJunction.ps1"
    "Import-UserScripts.ps1"
    "Invoke-Ternary.ps1"
    "Test-Null.ps1"
) | % { . (Join-Path $private:FunctionExportsRoot $_) }

# Aliases
$private:AliasExportsRoot = Join-Path $InstallPath "Custom Consoles\PowerShell\Exports\Aliases"
@(
    "0x003F+0x003A"
    "const"
    "Is"
) | % {
	$alias = $_
	if ($alias.StartsWith("0x")) {
		$alias = [string]::Concat(($alias | % Split '+' | % { [char][int]($_) }))
	}
	$command = Get-Content -Path (Join-Path $private:AliasExportsRoot ("{0}.alias" -f $_)) | Select-Object -First 1
	Set-Alias -Name $alias -Value $command -Force
}