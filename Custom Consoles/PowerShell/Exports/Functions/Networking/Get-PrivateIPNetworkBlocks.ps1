function Get-PrivateIPNetworkBlocks {    
    if ($null -eq ([System.AppDomain]::CurrentDomain.GetAssemblies() | ? FullName -eq "LukeSkywalker.IPNetwork, Version=1.3.2.0, Culture=neutral, PublicKeyToken=764160545cf0d618")) {
        [System.Reflection.Assembly]::LoadFile((Join-Path $ProfileConfig.Module.InstallPath "Libraries\Misc\LukeSkywalker.IPNetwork.dll")) | Out-Null    
    }

    Write-Host
    Write-Host -ForegroundColor Green "`t Private Class A Network Range"
    [LukeSkywalker.IPNetwork.IPNetwork]::IANA_ABLK_RESERVED1
    Write-Host
    Write-Host -ForegroundColor Green "`t Private Class B Network Range"
    [LukeSkywalker.IPNetwork.IPNetwork]::IANA_BBLK_RESERVED1
    Write-Host
    Write-Host -ForegroundColor Green "`t Private Class C Network Range"
    [LukeSkywalker.IPNetwork.IPNetwork]::IANA_CBLK_RESERVED1
}