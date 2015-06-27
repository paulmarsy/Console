function _Import-TfsAssemblies {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
	param()
	
	Add-Type -AssemblyName "Microsoft.TeamFoundation.Common, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
	Add-Type -AssemblyName "Microsoft.TeamFoundation.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
	Add-Type -AssemblyName "Microsoft.TeamFoundation.Build.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
	Add-Type -AssemblyName "Microsoft.TeamFoundation.VersionControl.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

	Add-Type -Path (Resolve-Path (Join-Path $Env:VS120COMNTOOLS "..\IDE\PrivateAssemblies\Microsoft.TeamFoundation.Build.Workflow.dll"))
}
