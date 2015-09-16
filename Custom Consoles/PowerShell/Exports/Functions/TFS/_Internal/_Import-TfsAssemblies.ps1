function _Import-TfsAssemblies {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
	param()
	
	switch ($ProfileConfig.TFS.Version)
	{
		"2015" {
			Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Common.dll")
			Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Client.dll")
			Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Build.Client.dll")
			Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.VersionControl.Client.dll")
			Add-Type -Path (Join-Path -Resolve -Path $Env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Build.Workflow.dll")	
		}
		"2013" {
			Add-Type -AssemblyName "Microsoft.TeamFoundation.Common, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -AssemblyName "Microsoft.TeamFoundation.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -AssemblyName "Microsoft.TeamFoundation.Build.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -AssemblyName "Microsoft.TeamFoundation.VersionControl.Client, Version=12.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -Path (Resolve-Path (Join-Path $Env:VS120COMNTOOLS "..\IDE\PrivateAssemblies\Microsoft.TeamFoundation.Build.Workflow.dll"))
		}
		"2010" {
			Add-Type -AssemblyName "Microsoft.TeamFoundation.Common, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -AssemblyName "Microsoft.TeamFoundation.Client, Version=19.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -AssemblyName "Microsoft.TeamFoundation.Build.Client, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -AssemblyName "Microsoft.TeamFoundation.VersionControl.Client, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
			Add-Type -AssemblyName "Microsoft.TeamFoundation.Build.Workflow, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
		}
	}	
}