# HKEY_CLASSES_ROOT or HKCR
Remove-PSDrive -Name HKCR -ErrorAction SilentlyContinue
New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -Scope Global | Out-Null

# HKEY_CURRENT_USER or HKCU
# Setup by default

# HKEY_LOCAL_MACHINE or HKLM
# Setup by default

# HKEY_USERS or HKU
Remove-PSDrive -Name HKU -ErrorAction SilentlyContinue
New-PSDrive -PSProvider Registry -Root HKEY_USERS -Name HKU -Scope Global | Out-Null

# HKEY_CURRENT_CONFIG or HKCC
Remove-PSDrive -Name HKCC -ErrorAction SilentlyContinue
New-PSDrive -PSProvider Registry -Root HKEY_CURRENT_CONFIG -Name HKCC -Scope Global | Out-Null