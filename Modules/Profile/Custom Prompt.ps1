function prompt {
	$wi = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $wp = New-Object 'System.Security.Principal.WindowsPrincipal' $wi
    if ($wp.IsInRole("Administrators")) { $color = "Red" }
    else { $color = "Green" }

    if ((Split-Path $pwd -NoQualifier) -eq "\") { $path = Split-Path $pwd -Qualifier }
	else { $path = (Split-Path $pwd -Parent | Get-ChildItem -Filter (Split-Path $pwd -Leaf) -Force).Name }

	Write-Host -ForegroundColor $color -NoNewLine "$path$"
	return " "
}