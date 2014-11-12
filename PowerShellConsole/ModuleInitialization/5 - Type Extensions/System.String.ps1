Update-TypeData	-TypeName System.String `
				-MemberType ScriptMethod `
				-MemberName RemoveString  `
				-Force `
				-Value {
					param($StringToRemove)
					
					$this.Replace($StringToRemove, $null)
				}