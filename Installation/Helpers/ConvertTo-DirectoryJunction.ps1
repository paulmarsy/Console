function ConvertTo-DirectoryJunction {
	param (
		[Parameter(Mandatory=$true)]$JunctionPath,
		[Parameter(Mandatory=$true)]$TargetPath
	)

	function Invoke-Junction {
		param(
			[Parameter(ParameterSetName="Add")]
			[Parameter(ParameterSetName="Remove")]
			$JunctionPath,
			[Parameter(ParameterSetName="Add")]
			$TargetPath,
			[Parameter(ParameterSetName="Remove")]
			[switch]$RemoveJunction
		)

		$argumentList = @()
		if ($RemoveJunction) {
			$argumentList += "-d"
		}

		$normalisedJunctionPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($JunctionPath).TrimEnd("\")
		$argumentList += "`"$($normalisedJunctionPath)`""

		if (-not $RemoveJunction) {
			$normalisedTargetPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TargetPath).TrimEnd("\")
			$argumentList += "`"$($normalisedTargetPath)`""
		}

		$junctionProcess = Start-Process -FilePath (Join-Path $PSScriptRoot "junction.exe") -WindowStyle Hidden -Wait -PassThru -ArgumentList $argumentList
		if ($junctionProcess.ExitCode -ne 0) {
			throw "Junction.exe return exit code $($junctionResult.ExitCode)"
		}
	}

	if (-not (Test-Path $TargetPath)) {
		New-Item $TargetPath -Type Directory -Force | Out-Null
	}

	if (Test-Path $JunctionPath) {
		$junctionPathAttributes = Get-Item -Path $JunctionPath -Force | % Attributes
		if ($false -eq ($junctionPathAttributes -band [System.IO.FileAttributes]::Directory)) {
		 	throw "$JunctionPath is not a directory so cannot be converted to a directory junction"
		}

		if ($true -eq ($junctionPathAttributes -band [System.IO.FileAttributes]::ReparsePoint)) {
			Invoke-Junction -JunctionPath $JunctionPath -RemoveJunction
		} else {
			$SourcePath = $JunctionPath
			Write-InstallMessage "The $(Split-Path $SourcePath -Leaf) directory currently exists, moving it's contents to $(Split-Path $TargetPath -Leaf)" -Type Warning

			Get-ChildItem -Path $SourcePath -Force | % { Move-Item -Path $_.FullName -Destination $TargetPath -Force }

			$remainingFiles = Get-ChildItem -Path $SourcePath -Force | Measure-Object -Line | Select-Object -ExpandProperty Lines
			if ($remainingFiles -gt 0) {
				throw "$remainingFiles files still exist in the $(Split-Path $SourcePath -Leaf) directory, please manually move them"
			}

			Remove-Item -Path $SourcePath -Recurse -Force
		}
	}

	Invoke-Junction -JunctionPath $JunctionPath -TargetPath $TargetPath
}
