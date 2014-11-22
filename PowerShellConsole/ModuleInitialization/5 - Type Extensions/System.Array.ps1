param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 1 }

$type = "System.Array"

Update-TypeData	-TypeName $type `
				-MemberType ScriptMethod `
				-MemberName Unique `
				-Force `
				-Value {
					$uniqueArray = {@()}.Invoke()
					$this | % {
						if ($uniqueArray.Contains($_)) { return }
						else { $uniqueArray.Add($_) }
					}

					return ($uniqueArray -as $this.GetType())
				}