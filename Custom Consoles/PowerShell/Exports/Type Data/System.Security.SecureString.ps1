@(
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
	},	@{
		MemberType = "ScriptMethod"
		MemberName = "SetReadOnly"
		Value = {
					param($String)
					
					$this.Clear()
					$String.ToCharArray() | % { $this.AppendChar($_) }
					$this.MakeReadOnly()
				}
	}, @{
		MemberType = "ScriptMethod"
		MemberName = "GetHash"
		Value = {
			param(
				[ValidateSet("MD5", "RIPEMD160", "SHA1", "SHA256", "SHA284", "SHA512")]$Algorithm
			)
			
			$this.Peek().GetHash($Algorithm)
		}
	}
)