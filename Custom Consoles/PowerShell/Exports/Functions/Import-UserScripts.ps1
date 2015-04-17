function Import-UserScripts {
    param(
        $IncludeFile = $ProfileConfig.General.UserScriptsIncludeFile,
        $AutoFolder = $ProfileConfig.General.UserScriptsAutoFolder,
        $ExportExclusionPattern = "_*.ps1",
        [switch]$ModuleInit
    )

    _Internal-Remove-ExistingUserScripts

    $comparisonObjects = _Internal-Import-UserScripts -IncludeFile $IncludeFile -AutoFolder $AutoFolder -ModuleInit:$ModuleInit

    Write-Host

    $ProfileConfig.Temp.UserScriptExports = @{
        Functions = ({@()}.Invoke())
        Aliases = ({@()}.Invoke())
        Total = 0
    }

    _Internal-Promote-NewUserObjects    -ReferenceObject $comparisonObjects.Reference.Functions `
                                        -DifferenceObject $comparisonObjects.Difference.Functions `
                                        -ProfileConfigSection $ProfileConfig.Temp.UserScriptExports.Functions `
                                        -PromotionScriptBlock {
                                            param($function)
                                            New-Item -Path "Function:Global:$($function.Name)" -Value ([ScriptBlock]::Create($function.Definition)) -Force
                                         } `
                                        -ExportExclusionPattern $ExportExclusionPattern

    _Internal-Promote-NewUserObjects    -ReferenceObject $comparisonObjects.Reference.Aliases `
                                        -DifferenceObject $comparisonObjects.Difference.Aliases `
                                        -AdditionalComparisonProperties = @("ReferencedCommand") `
                                        -ProfileConfigSection $ProfileConfig.Temp.UserScriptExports.Aliases `
                                        -PromotionScriptBlock {
                                            param($alias)
                                            Set-Alias -Name $alias.Name -Value $alias.Definition -Scope Global -Force
                                         } `
                                        -ExportExclusionPattern $ExportExclusionPattern

    if ($ProfileConfig.Temp.UserScriptExports.Total -ge 1) {
        Write-Host -ForegroundColor DarkGreen "Imported $($ProfileConfig.Temp.UserScriptExports.Total) total user objects"
    }
}

function _Internal-Remove-ExistingUserScripts {
    if ($ProfileConfig.Temp.ContainsKey("UserScriptExports")) {
        $ProfileConfig.Temp.UserScriptExports.Functions | Is -Not Null | % {
            Write-Warning "Removing previously imported user function $_"
            Remove-Item -Path "Function:$_" -Force
        }
        $ProfileConfig.Temp.UserScriptExports.Aliases | Is -Not Null | % {
            Write-Warning "Removing previously imported user alias $_"
            Remove-Item -Path "Alias:$_" -Force
        }
        $ProfileConfig.Temp.Remove("UserScriptExports")
        Write-Host
    }
}

function _Internal-Import-UserScripts {
    param($IncludeFile, $AutoFolder, $ModuleInit)

    $comparisonObjects = @{
        Reference = @{
            Functions =  (Get-ChildItem Function:)
            Aliases = (Get-ChildItem Alias:)
        }
    }

    if (-not (Test-Path $IncludeFile) -or (Is NullOrWhiteSpace -InputObject ([IO.File]::ReadAllText($IncludeFile)) -Bool) -and -not $ModuleInit) {
        Write-Error "Include file ($IncludeFile) is empty or does not exist"
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
    Get-ChildItem -Path $AutoFolder -Filter *.ps1 -Recurse -File | % {
        try {
            . "$($_.FullName)" | % {
                if (-not $hasOutput) {
                    $hasOutput = $true
                    Write-Host
                } 
                Write-Host -ForegroundColor DarkGray ("`t{0}" -f $_)
            }
        }
        catch { Write-Host; Write-Error "There was an error importing the automatically included file $($_.Name): $($_.Exception.Message)" }
    }
    Write-Host -ForegroundColor Green "$(?: { $hasOutput } { " ..." })Done"
    Pop-Location
    
    $comparisonObjects.Difference = @{
        Functions =  (Get-ChildItem Function:)
        Aliases = (Get-ChildItem Alias:)
    }

    return $comparisonObjects
}

function _Internal-Promote-NewUserObjects {
    param(
        $ReferenceObject,
        $DifferenceObject,
        $AdditionalComparisonProperties = @(),
        $ProfileConfigSection,
        $PromotionScriptBlock,
        $ExportExclusionPattern
    )

    $comparisonProperties = @("CommandType", "Name", "Definition", "ModuleName") + $AdditionalComparisonProperties
    Compare-Object -ReferenceObject $ReferenceObject -DifferenceObject $DifferenceObject -Property $comparisonProperties | 
                ? { $_.Name -notlike $ExportExclusionPattern -and $ExecutionContext.SessionState.Module.Name -eq $_.ModuleName } | 
                % {
                    Write-Host -NoNewLine -ForegroundColor DarkGray "Importing user $($_.CommandType.ToString().ToLower()) $($_.Name)... "
                    $PromotionScriptBlock.Invoke($_)
                    $ProfileConfigSection.Add($_.Name)
                    Write-Host -ForegroundColor DarkGreen "Done"
                } | Out-Null

    $ProfileConfig.Temp.UserScriptExports.Total += $ProfileConfigSection.Count
}