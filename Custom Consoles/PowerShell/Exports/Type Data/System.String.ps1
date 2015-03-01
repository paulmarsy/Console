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
		MemberName = "TrimStart"
		Value = {
					param([string]$StringToRemove)
					
					if ($this.StartsWith($StringToRemove)) {
						return $this.Remove(0, $StringToRemove.Length)
					} else {
						return $this
					}
				}
	}, @{
		MemberType = "ScriptMethod"
		MemberName = "TrimEnd"
		Value = {
					param([string]$StringToRemove)
					
					if ($this.EndsWith($StringToRemove)) {
						$this.Remove(($this.Length - $StringToRemove.Length), $StringToRemove.Length)
					} else {
						return $this
					}
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