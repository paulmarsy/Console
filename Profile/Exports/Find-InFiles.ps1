function Find-InFiles {
    [CmdletBinding()]
	param(
		$path,
		$pattern
    )
    
	Get-ChildItem $path -Recurse | Select-String -Pattern $pattern | group path | select name
}
@{Function = "Find-InFiles"}