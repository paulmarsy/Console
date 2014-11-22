param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 1 }

if (Test-Path Function:TabExpansion2) {
	Copy-Item -Path Function:TabExpansion2 -Destination Function:Global:TabExpansion2Backup -Force
}

$ProfileConfig.Temp.TabExpansion2 = @{
	CustomArgumentCompleters = @{}
	NativeArgumentCompleters = @{}
}


New-Item -Path Function:Global:TabExpansion2 -Force -Value ([ScriptBlock]::Create({
	<# Options include:
	   RelativeFilePaths - [bool]
	       Always resolve file paths using Resolve-Path -Relative.
	       The default is to use some heuristics to guess if relative or absolute is better.

	 To customize your own custom options, pass a hashtable to CompleteInput, e.g.
	       return [System.Management.Automation.CommandCompletion]::CompleteInput($inputScript,
	$cursorColumn,
	           @{ RelativeFilePaths=$false }
	#>

	[CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
	Param(
	  [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
	  [string] $inputScript,

	  [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 1)]
	  [int] $cursorColumn,

	  [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
	  [System.Management.Automation.Language.Ast] $ast,

	  [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
	  [System.Management.Automation.Language.Token[]] $tokens,

	  [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
	  [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

	  [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
	  [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
	  [Hashtable] $options = $null
	)

	End
	{
		$options += $ProfileConfig.Temp.TabExpansion2

		if ($PSCmdlet.ParameterSetName -eq 'ScriptInputSet')
		{
			$result = [System.Management.Automation.CommandCompletion]::CompleteInput($inputScript, $cursorColumn, $options)
		}
		else
		{
			$result = [System.Management.Automation.CommandCompletion]::CompleteInput($ast, $tokens, $positionOfCursor, $options)
		}

		return $result
	}
}))