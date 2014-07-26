function Get-UsersActiveDirectoryGroups {
	[CmdletBinding()]
	param
	(
		[Parameter()]$username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
		[Parameter()]$comparisonUsername
	)
	    
	Add-Type -AssemblyName System.DirectoryServices.AccountManagement            
	$ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain            
	$user = [System.DirectoryServices.AccountManagement.Principal]::FindByIdentity($ct,$userName)            
	$usergroups = $user.GetGroups() | Select-Object Name | % { $_.Name }
	
	if ($comparisonUsername) {
		Compare-Object $usergroups (Get-UsersActiveDirectoryGroups $comparisonUsername) | % {
			if ($_.SideIndicator -eq "<=") { $possessor = $username }
			if ($_.SideIndicator -eq "=>") { $possessor = $comparisonUsername }

			Write-Output "$possessor has $($_.InputObject)"
		}
	} else {
		$usergroups | ? { $null -ne $_ } | % { Write-Output $_ }
	}
}