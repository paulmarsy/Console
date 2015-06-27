function _Promote-NewUserObjects {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
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