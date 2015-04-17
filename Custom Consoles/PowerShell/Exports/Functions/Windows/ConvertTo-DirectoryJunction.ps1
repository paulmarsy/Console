function ConvertTo-DirectoryJunction {
	param (
		[Parameter(Mandatory=$true)]$JunctionPath,
		[Parameter(Mandatory=$true)]$TargetPath
	)

	function Invoke-Junction {
		param(
			[Parameter(ParameterSetName="Add")]
			[Parameter(ParameterSetName="Remove")]
			[Parameter(Mandatory=$true)]
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

		if (Get-Command -Name "junction.exe" -CommandType Application) {
			$junction = "junction.exe"
		} else {
			$junction = Join-Path $ProfileConfig.Module.InstallPath "Libraries\PATH Extensions\Sysinternals\junction.exe"
		}

		$junctionProcess = Start-Process -FilePath $junction -WindowStyle Hidden -Wait -PassThru -ArgumentList $argumentList
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
			Write-Warning "The $(Split-Path $SourcePath -Leaf) directory currently exists, moving it's contents to $(Split-Path $TargetPath -Leaf)"

			Get-ChildItem -Path $SourcePath -Force | % { Move-Item -Path $_.FullName -Destination $TargetPath -Force }
			Get-ChildItem -Path $TargetPath -Force -Recurse -Include "desktop.ini" | % { Set-ItemProperty -Path (Split-Path -Path $_ -Parent) -Name Attributes -Value "ReadOnly,System" }

			$remainingFiles = Get-ChildItem -Path $SourcePath -Force | Measure-Object -Line | Select-Object -ExpandProperty Lines
			if ($remainingFiles -gt 0) {
				throw "$remainingFiles files still exist in the $(Split-Path $SourcePath -Leaf) directory, please manually move them"
			}

			Remove-Item -Path $SourcePath -Recurse -Force
		}
	} elseif (-not (Test-Path (Split-Path $JunctionPath -Parent))) {
		New-Item (Split-Path $JunctionPath -Parent) -Type Directory -Force | Out-Null
	}

	Invoke-Junction -JunctionPath $JunctionPath -TargetPath $TargetPath
}
