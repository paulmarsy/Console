function Get-AbsolutePath {
    param(
        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$Path
    )
    
    return ([System.IO.Path]::GetFullPath($Path))
}