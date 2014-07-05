function GetCommandTemplate {
	[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$defaultBrowserProgId
    )

    $Shlwapi = Add-DllImport -dll "Shlwapi" -returnType "int" -methodName "AssocQueryString" -parameters @("int flags", "int str", "string pszAssoc", "string pszExtra", "ref char[] pszOut", "ref uint pcchOut")
    
	$commandTemplateBufferSize = [uint32]0
	$Shlwapi::AssocQueryString(0x00000000, 1, $defaultBrowserProgId, "open", [ref] $null, [ref] $commandTemplateBufferSize)

            
	#$commandTemplateStringBuilder = New-Object System.Text.StringBuilder($commandTemplateBufferSize)
	$commandTemplateStringBuilder = new-object char[] $commandTemplateBufferSize

	$hresult = $Shlwapi::AssocQueryString(0x00000000, 1, $defaultBrowserProgId, "open", [ref] $commandTemplateStringBuilder, [ref] $commandTemplateBufferSize)    
    if ($hresult -eq 0) { return $null }

    $global:t = $commandTemplateStringBuilder

    return $commandTemplateStringBuilder.ToString()
}


function Open-UrlWithDefaultBrowser
{
	[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$url
    )

    $defaultBrowserProgId = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice -Name "ProgId" | select -ExpandProperty ProgId

	$commandTemplate = GetCommandTemplate $defaultBrowserProgId

    $defaultBrowserPath = (Get-Item "HKCR:\$defaultBrowserProgId\shell\open\command").GetValue([String]::Empty)

    $shell32 = Add-DllImport -dll "Shell32" -returnType "int" -methodName "SHEvaluateSystemCommandTemplate" -parameters @("string pszCmdTemplate", "out string ppszApplication", "out string ppszCommandLine", "out string ppszParameters")
    Set-StrictMode -Off
    [string]$application = ""
    [string]$commandLine = ""
    [string]$parameters = ""
	$hresult = $shell32::SHEvaluateSystemCommandTemplate($commandTemplate, [ref] $application, [ref] $commandLine, [ref] $parameters)
	write-host $commandTemplate
	write-host $application
	write-host $commandLine
	write-host $parameters
	if ($hresult -eq 0) { return 0 }

	$parameters = $parameters.Replace("%L", $url).Replace("%l", $url).Replace("%1", $url)

    [System.Diagnostics.Process]::Start($application, $parameters)
}

@{Function = "Open-UrlWithDefaultBrowser"}