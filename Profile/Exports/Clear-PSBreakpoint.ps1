Set-Alias cbp Clear-PSBreakpoint
function Clear-PSBreakpoint
{
    Get-PSBreakpoint | Remove-PSBreakpoint
}
@{Function = "Clear-PSBreakpoint"; Alias = "cbp"}