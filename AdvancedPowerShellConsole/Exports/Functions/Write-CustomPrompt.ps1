function Write-CustomPrompt {
    $realLASTEXITCODE = $LASTEXITCODE

	$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal $windowsIdentity
    if ($windowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) { $securityColour = "Red" }
    else { $securityColour = "Green" }

    if ((Split-Path $pwd -NoQualifier) -eq "\") { $path = Split-Path $pwd -Qualifier }
	else { $path = Split-Path $pwd -Parent | Get-ChildItem -Filter (Split-Path $pwd -Leaf) -Force | Select-Object -ExpandProperty Name }

    if ($path) {
        Write-Host -ForegroundColor $securityColour -NoNewLine "$path"
        Write-VcsStatus
    } else {
        Write-Host -ForegroundColor $securityColour -NoNewLine "<Invalid Path>"
    }
    if ($NestedPromptLevel -ne 0) {
        Write-Host -ForegroundColor $securityColour -NoNewLine "($NestedPromptLevel)"
    }
    Write-Host -ForegroundColor $securityColour -NoNewLine "$"

    $global:LASTEXITCODE = $realLASTEXITCODE
	return " "
}