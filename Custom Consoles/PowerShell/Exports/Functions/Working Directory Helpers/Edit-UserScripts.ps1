function Edit-UserScript {
	param(
		[ValidateSet("Atom", "Code", "Default")]$Editor = "Default"
	)
	
	Open-Location -Location PowerShellScripts -Editor $Editor
}