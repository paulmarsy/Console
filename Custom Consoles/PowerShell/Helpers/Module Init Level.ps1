<#
 Based on a modified version of the PowerSploit script:
 	https://github.com/mattifestation/PowerSploit/blob/master/Exfiltration/Get-Keystrokes.ps1

 Contributed to by:
 	http://www.obscuresec.com/
    http://www.exploit-monday.com/
    https://github.com/mattifestation
 #>

try {
	if (Test-Path Env:\CustomConsolesModuleInitLevel) {
		return (Get-Item -Path Env:\CustomConsolesModuleInitLevel | % Value)
	}

	Add-Type -AssemblyName System.Windows.Forms

	$dynamicType = [System.AppDomain]::CurrentDomain.GetAssemblies() | % GetTypes | ? FullName -eq 'NativeMethods.User32'
	if ($null -eq $dynamicType) {
		$dynamicAssembly = [AppDomain]::CurrentDomain.DefineDynamicAssembly(
			(New-Object System.Reflection.AssemblyName('PowerShellConsoleNativeMethods')),
			[Reflection.Emit.AssemblyBuilderAccess]::Run
		)
		$dynamicModule = $dynamicAssembly.DefineDynamicModule('PowerShellConsoleNativeMethods', $false)
		$nativeMethodsUser32 = $dynamicModule.DefineType('NativeMethods.User32', 'Public, Class')

		$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
		$FieldArray =		[Reflection.FieldInfo[]]	@([Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),	[Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig'))
		$FieldValueArray =	[Object[]]					@('GetAsyncKeyState',													$true)
		$CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('user32.dll'), $FieldArray, $FieldValueArray)

		$PInvokeMethod = $nativeMethodsUser32.DefineMethod('GetAsyncKeyState', 'Public, Static', [Int16], [Type[]] @([Windows.Forms.Keys]))
		$PInvokeMethod.SetCustomAttribute($CustomAttribute)

		$dynamicType = $nativeMethodsUser32.CreateType()
	}

	function Check-IfKeyIsPressed {
		param([System.Windows.Forms.Keys]$Key)

		return (($dynamicType::GetAsyncKeyState($Key) -band 0x8000) -eq 0x8000)
	}

	$LControlKey	= Check-IfKeyIsPressed ([Windows.Forms.Keys]::LControlKey)
	$LShiftKey 		= Check-IfKeyIsPressed ([Windows.Forms.Keys]::LShiftKey)
	$LWin			= Check-IfKeyIsPressed ([Windows.Forms.Keys]::LWin)
	$LAlt			= Check-IfKeyIsPressed ([Windows.Forms.Keys]::LMenu)

	if ($LControlKey) {
		$level = 1
		if ($LShiftKey) { $level++ }
		if ($LWin) { $level++ }
		if ($LAlt) { $level++ }
		
		if ($level -gt 3) { $level = 3 }
	} else {
		$level = 0
	}
	

	if ($level -gt 0) {
		Write-Host -ForegroundColor DarkMagenta "`tModule Init Level Override Set (Level: $level)"
	}

	return $level
}
catch {
	return 0
}
