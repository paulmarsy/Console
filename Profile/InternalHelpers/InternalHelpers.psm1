Set-Alias export Export-Helper

function Export-Helper
{
  param ([parameter(mandatory=$true)] [validateset("function","variable")] $type,
  [parameter(mandatory=$true)] $name,
  [parameter(mandatory=$true)] $value)
  if ($type -eq "function")
   {
     Set-item "function:script:$name" $value
     Export-ModuleMember $name
   }
else
   {
     Set-Variable -scope Script $name $value
     Export-ModuleMember -variable $name
   }
}

Export-ModuleMember -Alias export