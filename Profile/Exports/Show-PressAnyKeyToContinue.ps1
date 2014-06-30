function Show-PressAnyKeyToContinue
{
	Write-Host -NoNewLine "Press any key to continue . . . "
	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
	Write-Host
}
@{Function = "Show-PressAnyKeyToContinue"}