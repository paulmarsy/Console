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
	},	@{
		MemberType = "ScriptMethod"
		MemberName = "Hash"
		Value = {
			param(
				[ValidateSet("MD5", "RIPEMD160", "SHA1", "SHA256", "SHA284", "SHA512")]$Algorithm
			)
			
			switch ($Algorithm)
			{
				"MD5" { $hasher = [System.Security.Cryptography.MD5]::Create() }
				"RIPEMD160" { $hasher = [System.Security.Cryptography.RIPEMD160]::Create() }
				"SHA1" { $hasher = [System.Security.Cryptography.SHA1]::Create() }
				"SHA256" { $hasher = [System.Security.Cryptography.SHA256]::Create() }
				"SHA284" { $hasher = [System.Security.Cryptography.SHA384]::Create() }
				"SHA512" { $hasher = [System.Security.Cryptography.SHA512]::Create() }
			}
			
    		[string]::Concat(($hasher.ComputeHash(([System.Text.Encoding]::UTF8.GetBytes($this))) | % ToString "X2"))
		}
	}
)