function Export-Module {
	param (
		[Parameter(Mandatory=$true)]$ModuleName,
		$ModuleFile,
		$ArgumentList = $null)

	if (Get-Module | ? Name -eq $ModuleName) {
		Remove-Module $ModuleName -Force
	}

	if ($null -eq $ModuleFile) {
		if ($null -eq (Get-Module -ListAvailable -Name $ModuleName)) {
			throw "Unable to find module $ModuleName to export"
		}
		$moduleImport = $ModuleName
	} else {
		if (-not (Test-Path $ModuleFile)) {
			throw "Unable to find module file $ModuleFile to export"
		}
		$moduleImport = $ModuleFile
	}

	Import-Module -Name:$moduleImport -ArgumentList:$ArgumentList -Global -Force
}