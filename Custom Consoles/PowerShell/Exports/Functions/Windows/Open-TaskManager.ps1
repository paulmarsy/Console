function Open-TaskManager {
	$procexpPath = Get-Command -Name "procexp.exe" -CommandType Application | % Path
	Start-Process -FilePath $procexpPath
}