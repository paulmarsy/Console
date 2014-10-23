$PowerShellConsoleStartUpMessage = [System.Environment]::GetEnvironmentVariable("PowerShellConsoleStartUpMessage", [System.EnvironmentVariableTarget]::Process)
if (-not [string]::IsNullOrWhiteSpace($PowerShellConsoleStartUpMessage)) {
    $verticalLine = 1..10 | % { "*" } | Join-String
    $horizontalLine = [string]::Concat((1..($verticalLine.Length * 2 + 2 + $PowerShellConsoleStartUpMessage.Length) | % { "*" }))
    $formattedMessage = "$horizontalLine`n$verticalLine $PowerShellConsoleStartUpMessage $verticalLine`n$horizontalLine"

    Write-Host
    Write-Host -ForegroundColor Red $formattedMessage
	Write-Host

    [System.Environment]::SetEnvironmentVariable("PowerShellConsoleStartUpMessage", $null, [System.EnvironmentVariableTarget]::Process)
}