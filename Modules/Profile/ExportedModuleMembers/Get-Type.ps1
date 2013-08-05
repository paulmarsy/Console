function Get-Type {
    [CmdletBinding()]
	param(  
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
		$obj
    )
    
    process {
		$obj | ? { $null -ne $_ } | % { $_.GetType() }
    }
}