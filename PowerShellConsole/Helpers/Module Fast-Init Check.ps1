<#
 Based on a modified version of the PowerSploit script:
 	https://github.com/mattifestation/PowerSploit/blob/master/Exfiltration/Get-Keystrokes.ps1

 Contributed to by:
 	http://www.obscuresec.com/
    http://www.exploit-monday.com/
    https://github.com/mattifestation
 #>
try {
	Add-Type -AssemblyName System.Windows.Forms

	try
	{
		$dynamicType = [NativeMethods.User32]
	}
	catch
	{
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

	$LControlKeyPressed = ($dynamicType::GetAsyncKeyState([Windows.Forms.Keys]::LControlKey) -band 0x8000) -eq 0x8000

	if ($LControlKeyPressed) {
		Write-Host -ForegroundColor Yellow "`t-Using Module Fast-Init-"
		return $true
	} else {
		return $false
	}
}
catch {
	return $false
}