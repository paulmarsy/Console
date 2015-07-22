$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Get-AbsolutePath" {
    It "converts a relative path to an absolute path" {
        Get-AbsolutePath -Path "C:\Windows\system\..\System32" | Should BeExactly "C:\Windows\System32"
    }
    
    It "doesn't modify absolute paths" {
        Get-AbsolutePath -Path "C:\test.ps1" | Should BeExactly "C:\test.ps1"
    }
}
