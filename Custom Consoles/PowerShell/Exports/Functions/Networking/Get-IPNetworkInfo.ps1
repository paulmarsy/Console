function Get-IPNetworkInfo {
    param(
        $Address
    )
    
    if ($null -eq ([System.AppDomain]::CurrentDomain.GetAssemblies() | ? FullName -eq "LukeSkywalker.IPNetwork, Version=1.3.2.0, Culture=neutral, PublicKeyToken=764160545cf0d618")) {
        [System.Reflection.Assembly]::LoadFile((Join-Path $ProfileConfig.Module.InstallPath "Libraries\Misc\LukeSkywalker.IPNetwork.dll")) | Out-Null    
    }

    [LukeSkywalker.IPNetwork.IPNetwork]::Parse($Address)
}