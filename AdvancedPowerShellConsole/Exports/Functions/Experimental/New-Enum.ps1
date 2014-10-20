function New-Enum {
  [CmdLetBinding()]
  param(   
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^(\w+\.)*\w+$')]
    [String]$Name,

    [Alias('Flags')]
    [Switch]$SetFlagsAttribute,

    [Parameter(Mandatory = $true)]
    [array]$Members
  )

  if ($SetFlagsAttribute) { $flagsAttribute = "[System.Flags]" }
  else { $flagsAttribute = [String]::Empty }

  $decodedMembers = $Members | Join-String -Separator ','
  Add-Type -TypeDefinition "$flagsAttribute public enum $Name { $decodedMembers }"
}