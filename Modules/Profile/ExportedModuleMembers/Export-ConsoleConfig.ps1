function Export-ConsoleConfig {    
    $Global:ConsoleConfig | Export-Clixml $Global:ConsoleConfig.ConsoleConfigFile
}