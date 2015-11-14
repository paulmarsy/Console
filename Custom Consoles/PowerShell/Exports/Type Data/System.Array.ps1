@(
	@{
		MemberType = "ScriptMethod"
		MemberName = "Unique"
		Value = {
					$uniqueArray = {@()}.Invoke()
					$this | % {
						if ($uniqueArray.Contains($_)) { return }
						else { $uniqueArray.Add($_) }
					}
	
					return ($uniqueArray -as $this.GetType())
				}
	}, @{
		MemberType = "ScriptMethod"
		MemberName = "Slice"		
		Value = {
			param(
        		[Parameter(Mandatory=$true)][ValidateRange(1,($this.Lenghth))]$Count
    		)
			
			 $slice = @()
   			 foreach ($i in $this) {
        		if ($slice.Count -eq $Count) {
           			Write-Output $slice
					$slice = @()
				}
				
				$slice += $i
			}
			Write-Output $slice
        }
        $slice.Add($item) > $null
	}, @{
		MemberType = "ScriptMethod"
		MemberName = "Reverse"		
		Value = {
    		if ($this.Length -eq 1) {
        		@($this[-1..-$this.Length])
    		} else {
        		@($this)
    		}
		}
	}
}