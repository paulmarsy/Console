$advancedPowerShellConsoleStartUpMessage = [System.Environment]::GetEnvironmentVariable("AdvancedPowerShellConsoleStartUpMessage", [System.EnvironmentVariableTarget]::Process)
if (-not [string]::IsNullOrWhiteSpace($advancedPowerShellConsoleStartUpMessage)) {
    $verticalLine = 1..10 | % { "*" } | Join-String
    $horizontalLine = [string]::Concat((1..($verticalLine.Length * 2 + 2 + $advancedPowerShellConsoleStartUpMessage.Length) | % { "*" }))
    $formattedMessage = "$horizontalLine`n$verticalLine $advancedPowerShellConsoleStartUpMessage $verticalLine`n$horizontalLine"

    Write-Host -ForegroundColor Red $formattedMessage

    [System.Environment]::SetEnvironmentVariable("AdvancedPowerShellConsoleStartUpMessage", $null, [System.EnvironmentVariableTarget]::Process)
}

$advancedPowerShellConsolePath = [System.Environment]::GetEnvironmentVariable("AdvancedPowerShellConsolePath", [System.EnvironmentVariableTarget]::Process)
if (-not [string]::IsNullOrWhiteSpace($advancedPowerShellConsolePath)) {
    Set-Location -Path $advancedPowerShellConsolePath
    [System.Environment]::SetEnvironmentVariable("AdvancedPowerShellConsolePath", $null, [System.EnvironmentVariableTarget]::Process)
}
