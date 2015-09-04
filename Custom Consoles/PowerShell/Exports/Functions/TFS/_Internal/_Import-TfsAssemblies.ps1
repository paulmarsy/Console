function _Import-TfsAssemblies {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
	param()
	
	Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Common.dll")
	Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Client.dll")
	Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Build.Client.dll")
	Add-Type -Path (Join-Path -Resolve -Path $env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.VersionControl.Client.dll")
	Add-Type -Path (Join-Path -Resolve -Path $Env:VS140COMNTOOLS -ChildPath "..\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Build.Workflow.dll")
}