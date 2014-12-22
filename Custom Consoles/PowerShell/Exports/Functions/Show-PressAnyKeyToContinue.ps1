function Show-PressAnyKeyToContinue
{
	Write-Host -NoNewLine "Press any key to continue . . . "
	$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
	Write-Host
}