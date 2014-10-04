function Invoke-Ternary {
	[CmdletBinding(DefaultParameterSetName="PredicateCheck")]
	param(
		[Parameter(ParameterSetName="PredicateCheck")][switch]$PredicateCheck,
		[Parameter(ParameterSetName="NullCheck")][switch]$NullCheck,
		[Parameter(ParameterSetName="NotNullCheck")][switch]$NotNullCheck,
		[Parameter(Mandatory=$true,Position=0)][scriptblock]$Predicate,
		[Parameter(Position=1)][scriptblock]$TrueValue,
		[Parameter(Position=2)][scriptblock]$FalseValue
	)

	$evaluation = & $Predicate
	if ($NullCheck -or $NotNullCheck) {
		switch ($null -eq $evaluation) {
			$true { if ($NullCheck) { $result = $true } elseif ($NotNullCheck) { $result = $false } }
			$false { if ($NullCheck) { $result = $false } elseif ($NotNullCheck) { $result = $true } }
		}	
	} else {
		if ($true -eq $evaluation) { $result = $true  }
		elseif ($false -eq $evaluation) { $result = $false }
		else { throw "Predicate function ($($Predicate.Ast.ToString())) did not return a boolean value" }
	}

	if ($true -eq $result -and $null -ne $TrueValue) { return (& $TrueValue) }
	elseif ($false -eq $result -and $null -ne $FalseValue) { return (& $FalseValue) }
	else { return $null }
}