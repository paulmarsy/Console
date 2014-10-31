function Invoke-Ternary {
	[CmdletBinding(DefaultParameterSetName="PredicateCheck")]
	param(
		[Parameter(Mandatory=$true,Position=0)][scriptblock]$Predicate,
		[Parameter(Position=1)][scriptblock]$TrueValue,
		[Parameter(Position=2)][scriptblock]$FalseValue,
		[Parameter(ParameterSetName="PredicateCheck")][switch]$PredicateCheck,
		[Parameter(ParameterSetName="NullCheck")][switch]$NullCheck,
		[switch]$Not
	)

	$evaluation = & $Predicate
	if ($PSCmdlet.ParameterSetName -eq "NullCheck") {
		$result = ($null -eq $evaluation)
	} elseif ($PSCmdlet.ParameterSetName -eq "PredicateCheck") {
		$result = switch ($evaluation) {
			$true { $true }
			$false { $false }
			default { throw "Predicate function ($($Predicate.Ast.ToString())) did not return a boolean value" }
		}

	} else {
		throw "Unknown check"
	}

	if ($Not) {
		$result = -not $result
	}

	if ($true -eq $result -and $null -ne $TrueValue) { return (& $TrueValue) }
	elseif ($false -eq $result -and $null -ne $FalseValue) { return (& $FalseValue) }
	else { return $null }
}