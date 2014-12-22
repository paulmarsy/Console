function Get-FavoriteBuildDefinitions {
	[CmdletBinding()]
	param
	(
		$tfsServerUrl = $ProfileConfig.TFS.Server
	)

    $tpcFactory = _Get-TfsTpcFactory $tfsServerUrl
	$buildServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.Build.Client.IBuildServer")
 	$ims = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.Framework.Client.IIdentityManagementService")

	$ims.ReadIdentity([Microsoft.TeamFoundation.Framework.Common.IdentitySearchFactor]::AccountName, ("{0}\{1}" -f ([Environment]::UserDomainName), ([Environment]::UserName)), [Microsoft.TeamFoundation.Framework.Common.MembershipQuery]::Expanded, ([Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]'ExtendedProperties,IncludeReadFromSource,TrueSid')) | 
		% { $_.GetProperties([Microsoft.TeamFoundation.Framework.Common.IdentityPropertyScope]::Local) } | 
		% GetEnumerator | 
		? { $_.Key.StartsWith("Microsoft.TeamFoundation.Framework.Server.IdentityFavorites..") } |
		% Value |
		ConvertFrom-Json |
		? type -eq "Microsoft.TeamFoundation.Build.Definition" |
		% data |
		% { $buildServer.GetBuildDefinition($_) }
}