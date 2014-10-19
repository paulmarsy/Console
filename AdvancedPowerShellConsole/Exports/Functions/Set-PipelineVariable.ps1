function Set-PipelineVariable {
	param(
		[Parameter(ValueFromPipeline = $true)]$InputObject,
		[Parameter(Mandatory = $true)][string]$Name,
		[Parameter(Mandatory = $true)][scriptblock]$Expression
	)
    
    PROCESS {
		$InputObject | % {
			$pipelineVariable = $Expression.Invoke($_)
			
			# Set variable to the parent scope
			New-Variable -Name $Name -Value $pipelineVariable -Force -Scope 1

			return $_
		}
    }
}