Invoke-InstallStep "Running NGen on common executables" {
	$ngen = Join-Path ([System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()) "ngen.exe"
	@(
		(Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Custom Helper Apps\ExtensibleEnvironmentTester\ExtensibleEnvironmentTester.exe")
	) | % {
		Write-InstallMessage "Generate native images for $(Split-Path -Path  $_ -Leaf)..."
		& $ngen install "$_" /nologo /silent
	}
}