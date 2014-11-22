param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

# HKEY_CLASSES_ROOT or HKCR
if (Test-Path HKCR:) {
	Remove-PSDrive -Name HKCR
}
New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -Scope Global | Out-Null

# HKEY_CURRENT_USER or HKCU
# Setup by default

# HKEY_LOCAL_MACHINE or HKLM
# Setup by default

# HKEY_USERS or HKU
if (Test-Path HKU:) {
	Remove-PSDrive -Name HKU
}
New-PSDrive -PSProvider Registry -Root HKEY_USERS -Name HKU -Scope Global | Out-Null

# HKEY_CURRENT_CONFIG or HKCC
if (Test-Path HKCC:) {
	Remove-PSDrive -Name HKCC
}
New-PSDrive -PSProvider Registry -Root HKEY_CURRENT_CONFIG -Name HKCC -Scope Global | Out-Null