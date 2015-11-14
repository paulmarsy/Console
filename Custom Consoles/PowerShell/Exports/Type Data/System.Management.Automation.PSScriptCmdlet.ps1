@(
	@{
        TypeName = 'System.Management.Automation.PSScriptCmdlet'
		MemberType = "ScriptMethod"
		MemberName = "ThrowTerminatingException"
		Value = {
			param(
				[Parameter(Position=0, Mandatory=$true)][ValidateNotNull()][System.Exception]$Exception,				
				[Parameter(Position=1, Mandatory=$true)][ValidateNotNull()][System.Management.Automation.ErrorCategory]$ErrorCategory,
				[Parameter(Position=2, Mandatory=$false)][System.Object]$TargetObject = $null
			)

			$errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord -ArgumentList @($Exception,
																										 $Exception.GetType().FullName,
																										 $ErrorCategory,
																										 $TargetObject)
        	$this.ThrowTerminatingError($errorRecord)
		}
	}
) 