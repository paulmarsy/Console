$proceed = Confirm-InstallSetting "Do you want to allow optional tweaks to Microsoft Windows and builtin applications?"

if ($proceed) {
	Write-InstallMessage -EnterNewScope "Configuring Windows Settings / Windows Applications"

	Get-ChildItem ".\Windows Settings" -Filter *.ps1 -File | Sort-Object Name | % { & $_.FullName }

	Exit-Scope
}