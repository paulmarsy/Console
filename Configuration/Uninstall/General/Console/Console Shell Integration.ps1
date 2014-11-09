@(
	@{Name = "Open PowerShell" },
	@{Name = "Open PowerShell (No Profile)" },
	@{Name = "Open PowerShell (Administrator)" },
	@{Name = "Open Command" },
	@{Name = "Open Command (Administrator)" }
) | % {
	$link = $_
	Invoke-InstallStep "Removing '$($link.Name)' Shell Integration" {
		@("*", "Directory\Background", "Folder", "Drive") | % { 
			$key = "HKCU:\Software\Classes\$_\shell\$($link.Name)"
			if (Test-Path $key) {
				Remove-Item $key -Recurse -Force
			}
		}
	}
}