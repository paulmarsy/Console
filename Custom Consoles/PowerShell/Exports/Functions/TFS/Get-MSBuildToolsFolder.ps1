function Get-MSBuildToolsFolder {
    [CmdletBinding()]
	param (
        [Parameter(Mandatory=$true)]
		[ValidateSet("2.0", "3.5", "4.0", "12.0")][string]$ToolsVersion,
        [switch]$AddToPath
	)

	$toolsFolder = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\" | 
            				? PSChildName -eq $ToolsVersion |
            				Sort-Object {[double]$_.PSChildName} -Descending | 
            				Select-Object -First 1 | 
            				Get-ItemProperty -Name MSBuildToolsPath |
            				Select -ExpandProperty MSBuildToolsPath
	    
	if (-not (Test-Path $toolsFolder)) {
		throw "Unable to find the MSBuild Tools Folder for version '$ToolsVersion' at '$toolsFolder'"
	}
    
    if ($AddToPath) {
        $Env:Path = "{0};{1}" -f $Env:Path.TrimEnd(';'), $toolsFolder
        Write-Host -ForegroundColor Green "MSBuild Tools Folder for $ToolsVersion has been added to PATH."
    } else {
        return $toolsFolder    
    }
}