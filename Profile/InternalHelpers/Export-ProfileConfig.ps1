function Export-ProfileConfig {    
    $ProfileConfig | Export-Clixml $profileConfigFile
}