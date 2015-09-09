function Connect-SQL {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]$SqlServer,
        [Parameter(Position=1)]$DefaultDatabase,
        $Username = $null,
        $Password = $null
    )

    $sqlServerClientRegistryKey = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server\120\Tools\ClientSetup"
    if (Test-Path $sqlServerClientRegistryKey) {
        $sqlToolsPath = Get-ItemProperty -Path $sqlServerClientRegistryKey | % "SqlToolsPath"
    }

    if ($null -eq $sqlServerClientRegistryKey -or $null -eq $sqlToolsPath) {
        throw "Unable to find SQL Server Tools Path, have the SQL Server tools been installed?"
    }

    $ssmsPath = Join-Path $sqlToolsPath "ssms.exe"
    if (-not (Get-Command -Name $ssmsPath -CommandType Application)) {
        throw "Unable to find SQL Server Management Tools, has it been installed?"
    } 

    $arguments = @()
    if ($SqlServer) {
        $arguments += @("-S $SqlServer") 
        if ($DefaultDatabase) { $arguments += @("-d $DefaultDatabase") }
        if ($null -ne $Username -and $null -ne $Password) { 
            $arguments += @("-U $Username")
            $arguments += @("-P $Password")
        } else {
            $arguments += @("-E")
        }
    }

    Start-Process -FilePath $ssmsPath -ArgumentList $arguments
}