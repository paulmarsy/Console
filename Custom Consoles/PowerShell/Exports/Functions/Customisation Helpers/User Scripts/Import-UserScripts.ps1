function Import-UserScripts {
    param(
        $IncludeFile = $ProfileConfig.General.UserScriptsIncludeFile,
        $AutoFolder = $ProfileConfig.General.UserScriptsAutoFolder,
        $ExportExclusionPattern = "_*.ps1",
        [switch]$ModuleInit
    )
    
    if ((Test-PowerShellScript -File $IncludeFile -Quiet:$ModuleInit) -eq $false) {
        $message = "User's custom include script file has errors, unable to continue."
        if ($ModuleInit) {
            Write-Host -ForegroundColor Red $message
            return
        } else {
            throw $message
        }
    }
    
    $autoIncludeValidationProblems = Test-PowerShellDirectory -Directory $AutoFolder -ReturnNumberOfProblems -Quiet:$ModuleInit
	if ($autoIncludeValidationProblems -gt 0) {
        $message = "User's auto-included scripts have $autoIncludeValidationProblems errors, unable to continue."
        if ($ModuleInit) {
            Write-Host -ForegroundColor Red $message
            return
        } else {
            throw $message
        }
	}

    _Remove-ExistingUserScripts

    $comparisonObjects = _Import-UserScripts -IncludeFile $IncludeFile -AutoFolder $AutoFolder -ModuleInit:$ModuleInit

    Write-Host

    $ProfileConfig.Temp.UserScriptExports = @{
        Functions = ({@()}.Invoke())
        Aliases = ({@()}.Invoke())
        Total = 0
    }

    _Promote-NewUserObjects     -ReferenceObject $comparisonObjects.Reference.Functions `
                                -DifferenceObject $comparisonObjects.Difference.Functions `
                                -ProfileConfigSection $ProfileConfig.Temp.UserScriptExports.Functions `
                                -PromotionScriptBlock {
                                   param($function)
                                        New-Item -Path "Function:Global:$($function.Name)" -Value ([ScriptBlock]::Create($function.Definition)) -Force
                                    } `
                                -ExportExclusionPattern $ExportExclusionPattern

    _Promote-NewUserObjects     -ReferenceObject $comparisonObjects.Reference.Aliases `
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