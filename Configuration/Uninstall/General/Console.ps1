Write-InstallMessage -EnterNewScope "Deconfiguring Console"

Get-ChildItem ".\Console" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }

Exit-Scope