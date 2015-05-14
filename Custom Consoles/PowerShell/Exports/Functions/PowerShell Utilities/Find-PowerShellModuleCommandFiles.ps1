function Find-PowerShellModuleCommandFiles {
    [CmdletBinding()]
    param(
        [ValidateScript({ Test-Path $_ })][string]$Path = $PWD.Path,
        $FileNameOutputTransform = { param($FileName); ". `"`$(Join-Path `$PSScriptRoot '$FileName')`"" },
        [switch]$CopyToClipboard
    )
    
    $pathRootLength = Resolve-Path $Path | % Path | % Length
    
    $files = Get-ChildItem -Path $Path -File -Recurse -Include "*.ps1" -Exclude "*.Tests.ps1" |
        % { $_.FullName.Substring($pathRootLength) } |
        % {
            if ($null -ne $FileNameOutputTransform) { $FileNameOutputTransform.Invoke($_) }
            else { $_ }
        }
        
    if ($CopyToClipboard) {
        Set-Clipboard -Text ([string]::Join([System.Environment]::NewLine, $files))
        Write-Host "Module command files output copied to clipboard."
    }
    else { Write-Output $files }
}