function Test-BuildDefinition {
    [OutputType([bool])]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]$Uri
    )
    
    BEGIN {
        $BuildServer = Get-BuildServer
        $BuildDefinitionsExist = $false
    }

    PROCESS {
        $Uri | % { 
            if ($null -ne ($BuildServer.QueryBuildDefinitionsByUri($_) | % Definitions)) { $BuildDefinitionsExist = $true }
        }
    }
    
    END {
        return $BuildDefinitionsExist
    }
}