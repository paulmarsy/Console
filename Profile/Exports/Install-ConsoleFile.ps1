function Install-ConsoleFile {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        $installFileName
    )

    $installFileName = ($installFileName -join " ") + ".ps1"
    $installFilePath = Join-Path (Join-Path $InstallPath "Install") $installFileName
    
    if (Test-Path $installFilePath) {
        & $installFilePath -InstallPath $InstallPath
    } else {
        (Get-ChildItem $pwd -Filter *.ps1 | Select-Object).BaseName
    }
}