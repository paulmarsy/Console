function Find-WinAPIFunction
{
    <#
    .SYNOPSIS
        Searches all loaded assemblies in your PowerShell session for a
        Windows API function.

    .PARAMETER Module
        Specifies the name of the module that implements the function. This
        is typically a system dll (e.g. kernel32.dll).

    .PARAMETER FunctionName
        Specifies the name of the function you're searching for.

    .OUTPUTS
        [System.Reflection.MethodInfo]

    .EXAMPLE
        Find-WinAPIFunction kernel32.dll CopyFile

    #>
    [CmdletBinding()]
    [OutputType([System.Reflection.MethodInfo])]

    param
    (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Module,
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FunctionName
    )

    [System.AppDomain]::CurrentDomain.GetAssemblies() |
        % { $_.GetTypes() } |
            % { $_.GetMethods('NonPublic, Public, Static') } |
                % { $MethodInfo = $_; $_.GetCustomAttributes($false) } |
                    ? {
                        $MethodInfo.Name.ToLower() -eq $FunctionName.ToLower() -and
                        $_.Value -eq $Module
                    } | % { $MethodInfo }
}