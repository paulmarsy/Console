function _Import-UserScripts {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
    param($IncludeFile, $AutoFolder, $ModuleInit)

    $comparisonObjects = @{
        Reference = @{
            Functions =  (Get-ChildItem Function:)
            Aliases = (Get-ChildItem Alias:)
        }
    }

    if (-not (Test-Path $IncludeFile) -or (Is NullOrWhiteSpace -InputObject ([IO.File]::ReadAllText($IncludeFile)) -Bool) -and -not $ModuleInit) {
        Write-Warning "Include file ($IncludeFile) is empty or does not exist"
    } else {
        Push-Location (Split-Path -Path $IncludeFile -Parent)
        try {
            Write-Host -NoNewLine "Loading default user include file $(Split-Path -Path $IncludeFile -Leaf)... "
            $hasOutput = $false
            . "$IncludeFile" | % {
                if (-not $hasOutput) {
                    $hasOutput = $true
                    Write-Host
                } 
                Write-Host -ForegroundColor DarkGray ("`t{0}" -f $_)
            }
            Write-Host -ForegroundColor Green "$(?: { $hasOutput } { " ..." })Done"
         }
        catch { Write-Error "There was an error importing the user include file: $($_.Exception.Message)" }
        Pop-Location
    }

    Push-Location $AutoFolder
    Write-Host -NoNewLine "Loading auto incude files from $(Split-Path -Path $AutoFolder -Leaf) folder... "
    $hasOutput = $false
    $file = [string]::Empty
    Get-ChildItem -Path $AutoFolder -Filter *.ps1 -Recurse -File -PipelineVariable file | % {
        try {
            . "$($_.FullName)" | % {
                if (-not $hasOutput) {
                    $hasOutput = $true
                    Write-Host
                } 
                Write-Host -ForegroundColor DarkGray ("`t{0}" -f $_)
            }
        }
        catch { Write-Host; Write-Error "There was an error importing the automatically included file $($file.Name): $($_.Exception.Message)" }
    }
    Write-Host -ForegroundColor Green "$(?: { $hasOutput } { " ..." })Done"
    Pop-Location
    
    $comparisonObjects.Difference = @{
        Functions =  (Get-ChildItem Function:)
        Aliases = (Get-ChildItem Alias:)
    }

    return $comparisonObjects
}