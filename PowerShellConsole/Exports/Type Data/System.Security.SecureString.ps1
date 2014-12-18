param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

@{
	MemberType = "ScriptMethod"
	MemberName = "Peek"
	Value = {
				try {
					$binarySecureString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($this)
					return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($binarySecureString)
				} finally {
					if ($null -ne $binarySecureString) {
						[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($binarySecureString)
					}
				}
			}
}