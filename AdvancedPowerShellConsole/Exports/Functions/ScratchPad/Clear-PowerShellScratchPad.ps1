function Clear-PowerShellScratchPad {
	$scratchpadFolder = $ProfileConfig.General.PowerShellScratchpadFolder
	Remove-Item $scratchpadFolder -Force
	New-Item $scratchpadFolder -Type Directory -Force | Out-Null
}