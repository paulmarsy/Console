function Import-DotNetType {
    param(
        [Parameter(Position=0,Valuefrompipeline=$True,Mandatory=$True)]
        [type]$Type
    )

    if (Get-Module -Name $Type.FullName) {
        write-host "see it"
        Remove-Module -Name $Type.FullName -Force
    }  
    New-Module {
        param($Type)
         
        $exports = $Type.GetMethods("Static,Public").Name | Sort-Object -Unique | % { "$($Type.Name)-$_" }

        $exports | % {
                $methodName = $_
                New-Item "function:-$methodName" -Value {
                        ($Type.FullName -as [Type])::$methodName.Invoke($args)
                    }.GetNewClosure()
            }
        Export-ModuleMember -function *
    } -Name $Type.FullName -ArgumentList $Type | Import-Module -Global
}