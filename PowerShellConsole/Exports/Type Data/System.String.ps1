@(
	@{
		MemberType = "ScriptMethod"
		MemberName = "RemoveString"
		Value = {
					param($StringToRemove)
					
					$this.Replace($StringToRemove, ([string]::Empty))
				}
	}, @{
		MemberType = "ScriptMethod"
		MemberName = "Expand"
		Value = {
					$ExecutionContext.InvokeCommand.ExpandString($this)
				}
	}, @{
		MemberType = "ScriptMethod"
		MemberName = "ToScriptBlock"
		Value = {
					[ScriptBlock]::Create($this)
				}
	}, @{
		MemberType = "ScriptMethod"
		MemberName = "LikeAny"
		Value = {
					param(
						[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][System.String[]]$Values
					)
					$Values | ? { $this -like $_ } | Measure-Object -Line | ? Lines -gt 0 | % { $true }
				}
	}
)