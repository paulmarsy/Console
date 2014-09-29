function Invoke-Ternary {
	[CmdletBinding(DefaultParameterSetName="PredicateCheck")]
	param(
		[Parameter(ParameterSetName="PredicateCheck")][switch]$PredicateCheck,
		[Parameter(ParameterSetName="NullCheck")][switch]$NullCheck,
		[Parameter(ParameterSetName="NotNullCheck")][switch]$NotNullCheck,
		[Parameter(Mandatory=$true,Position=0)][scriptblock]$Predicate,
		[Parameter(Mandatory=$true,Position=1)][scriptblock]$TrueValue,
		[Parameter(Mandatory=$true,Position=2)][scriptblock]$FalseValue
	)

	$result = & $Predicate
	if ($NullCheck -or $NotNullCheck) {
		switch ($null -eq $result) {
			$true { if ($NullCheck) { return (& $TrueValue) } elseif ($NotNullCheck) { return (& $FalseValue) } }
			$false { if ($NullCheck) { return (& $FalseValue) } elseif ($NotNullCheck) { return (& $TrueValue) } }
		}	
	} else {
		if ($true -eq $result) { return (& $TrueValue) }
		elseif ($false -eq $result) { return (& $FalseValue) }
		else { throw "Predicate function ($($Predicate.Ast.ToString())) did not return a boolean value" }
	}
}