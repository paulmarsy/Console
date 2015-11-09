function Open-PowerShellConsoleHomeFolder {
	param(
		[ValidateSet("Atom", "Code", "Default")]$Editor = "Default"
	)
	
	Open-Location -Location Home -Editor $Editor
}