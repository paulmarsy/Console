function Connect-SQL {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]$SqlServer,
        [Parameter(Position=1)]$DefaultDatabase,
        $Username = $null,
        $Password = $null
    )

    $arguments = @("-nosplash", "-S $SqlServer")
    if ($DefaultDatabase) { $arguments += @("-d $DefaultDatabase") }
    if ($null -ne $Username -and $null -ne $Password) { 
        $arguments += @("-U $Username")
        $arguments += @("-P $Password")
    } else {
        $arguments += @("-E")
    }

    Start-Process -FilePath "ssms.exe" -ArgumentList $arguments
}