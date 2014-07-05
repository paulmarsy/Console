function New-DynamicModuleBuilder {
  # .SYNOPSIS
  #   Creates a new assembly and a dynamic module within the current AppDomain.
  # .DESCRIPTION
  #   Prepares a System.Reflection.Emit.ModuleBuilder class to allow construction of dynamic types. The ModuleBuilder is created to allow the creation of multiple types under a single assembly.
  # .PARAMETER AssemblyName
  #   A name for the in-memory assembly.
  # .INPUTS
  #   System.Reflection.AssemblyName
  # .OUTPUTS
  #   System.Reflection.Emit.ModuleBuilder
  # .EXAMPLE
  #   New-DynamicModuleBuilder "Example.Assembly"
  
  [CmdLetBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [Reflection.AssemblyName]$AssemblyName
  )
  
  $AppDomain = [AppDomain]::CurrentDomain
 
  # Multiple assemblies of the same name can exist. This check aborts if the assembly name exists on the assumption
  # that this is undesirable.
  $AssemblyRegEx = "^$($AssemblyName.Name -replace '\.', '\.'),"
  if ($AppDomain.GetAssemblies() |
    Where-Object { 
      $_.IsDynamic -and $_.Fullname -match $AssemblyRegEx }) {
 
    Write-Error "Dynamic assembly $($AssemblyName.Name) already exists."
    break
  }
  
  # Create a dynamic assembly in the current AppDomain
  $AssemblyBuilder = $AppDomain.DefineDynamicAssembly(
    $AssemblyName, 
    [Reflection.Emit.AssemblyBuilderAccess]::Run
  )
 
  $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule($AssemblyName.Name)

  return $ModuleBuilder
}
@{Function = "New-DynamicModuleBuilder"}