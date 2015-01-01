function Get-TypeAccelerators {
	[PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get | Sort-Object -Property Key
}