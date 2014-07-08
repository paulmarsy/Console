function Convert-Temperature
{
	[CmdletBinding()]
	param(
	 [Parameter(Mandatory=$true)][double]$Temperature,
	 [Parameter(Mandatory=$true)][string][ValidateSet("C", "F", "K")]$From,
	 [Parameter(Mandatory=$true)][string][ValidateSet("C", "F", "K")]$To
	)

	switch ($From) {
	 "C" {$data = $Temperature}
	 "F" {$data = ($Temperature -32) * (5/9 )}
	 "K" {$data = $Temperature - 273.15}
	}

	switch ($To) {
	 "C" {$output = $data}
	 "F" {$output = ($data * (9/5)) + 32 }
	 "K" {$output = $data + 273.15}
	}
	
	[Math]::Round($output,2)
}

@{Function = "Convert-Temperature"}