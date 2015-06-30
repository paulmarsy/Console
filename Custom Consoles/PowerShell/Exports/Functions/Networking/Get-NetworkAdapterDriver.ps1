function Get-NetworkAdapterDriver {
    Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" -ErrorAction Ignore |
        % { Get-ItemProperty -Path $_.PSPath -Name DriverDesc } |
        Select-Object -ExpandProperty DriverDesc
}