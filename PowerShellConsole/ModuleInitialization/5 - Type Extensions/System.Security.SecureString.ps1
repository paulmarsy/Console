param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 1 }

$type = "System.Security.SecureString"

Update-TypeData	-TypeName $type `
				-MemberType ScriptMethod `
				-MemberName Peek `
				-Force `
				-Value {
					try {
						$binarySecureString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($this)
						return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($binarySecureString)
					} finally {
						if ($null -ne $binarySecureString) {
							[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($binarySecureString)
						}
					}
				}