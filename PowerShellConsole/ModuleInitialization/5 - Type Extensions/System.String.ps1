param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$type = "System.String"

Update-TypeData	-TypeName $type `
				-MemberType ScriptMethod `
				-MemberName RemoveString `
				-Force `
				-Value {
					param($StringToRemove)
					
					$this.Replace($StringToRemove, $null)
				}

Update-TypeData	-TypeName $type `
				-MemberType ScriptMethod `
				-MemberName Expand `
				-Force `
				-Value {
					$ExecutionContext.InvokeCommand.ExpandString($this)
				}

Update-TypeData	-TypeName $type `
				-MemberType ScriptMethod `
				-MemberName ToScriptBlock `
				-Force `
				-Value {
					[ScriptBlock]::Create($this)
				}

Update-TypeData	-TypeName $type `
				-MemberType ScriptMethod `
				-MemberName LikeAny `
				-Force `
				-Value {
					param(
						[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][System.String[]]$Values
					)
					$Values | ? { $this -like $_ } | Measure-Object -Line | ? Lines -gt 0 | % { $true }
				}
