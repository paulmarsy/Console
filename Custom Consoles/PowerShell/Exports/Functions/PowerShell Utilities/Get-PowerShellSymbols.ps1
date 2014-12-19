function Get-PowerShellSymbols
{
	param([switch]$IncludeExtended)

	$baseSymbols = @(' ', '$', "'", '"', '{', '}', '|', '`', ',', '(', ')', '.')
	$extendedSymbols = @('@', '*', '+', '-', '\', '/', '[', ']')

	if ($IncludeExtended) { return ($baseSymbols + $extendedSymbols) }
	else { return $baseSymbols }
}

