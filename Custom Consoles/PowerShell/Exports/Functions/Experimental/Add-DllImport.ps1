function Add-DllImport {
	[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$dll,
        [Parameter(Mandatory=$true)]$returnType,
        [Parameter(Mandatory=$true)]$methodName,
        [Parameter(Mandatory=$true)]$parameters
    )

	$decodedParameters = $parameters | Join-String -Separator ', '
    $MethodDefinition = @"
[DllImport("$($dll).dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern $returnType $methodName($decodedParameters);
"@

	Add-Type -MemberDefinition $MethodDefinition -Name $dll -PassThru
}