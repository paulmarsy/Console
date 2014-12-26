function Repair-ConsoleGitRepo {
	_workOnConsoleWorkingDirectory {
		Write-Host -ForegroundColor Green "Attempting to repair Console Git repo..."

		try {
			$gitProcesses = Get-Process -Name "git"

			Write-Host -NoNewLine -ForegroundColor Green ("Killing {0} Git processes... " -f ($gitProcesses | Measure-Object -Line | Select-Object -ExpandProperty Line))
			$gitProcesses | Stop-Process -Force
			Write-Host -ForegroundColor Green "Done"
		}
		catch {
			Write-Host -ForegroundColor Yellow "No Git processes running"
		}

		Get-ChildItem -File -Path ".\.git\" -Include "index.lock" | % {
			Write-Host -NoNewLine -ForegroundColor Green "Removing Git index lock file $($_.FullName)... "
			Remove-Item -Path $_.FullName -Force	
			Write-Host -ForegroundColor Green "Done"
		}

		Write-Host -ForegroundColor Green "Git garbage collection..."
		_invokeGitCommand "gc --prune --aggressive --auto"

		Write-Host -ForegroundColor Green "Git pruning unreachable objects in the object database..."
		_invokeGitCommand "prune --progress --verbose"

		Write-Host -ForegroundColor Green "Git pruning unreachable objects in pack files..."
		_invokeGitCommand "prune-packed"

		Write-Host -ForegroundColor Green "Git integrity check..."
		_invokeGitCommand "fsck --full --strict --progress --unreachable --dangling --cache"

		Write-Host -ForegroundColor Green "Finished repairing Console Git repo"
	}
}