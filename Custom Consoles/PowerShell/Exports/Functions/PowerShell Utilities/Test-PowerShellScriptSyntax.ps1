function Test-PowerShellScriptSyntax
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $File,
        $BaseDirectory
    )

    BEGIN {
        if ($null -ne $BaseDirectory) {
            $baseDirectoryLength = Resolve-Path $BaseDirectory | % Path | % Length
        } else {
            $baseDirectoryLength = 0
        }
    }

    PROCESS {
        $File | % {
            $relativeFileName = $File.Remove(0, $baseDirectoryLength)
            if (-not (Test-Path $File)) {
                Write-Output (New-Object -Type PSObject -Property @{
                    File = $relativeFileName
                    Error = "Unable to find PowerShell script file"
                })
            } else {
                try {
                    $scriptContents = Get-Content -Path $File -Raw
                    $parseErrors = $null
                    [System.Management.Automation.PSParser]::Tokenize($scriptContents, [ref]$parseErrors) | Out-null
                    if ($parseErrors.Count -gt 0) {
                        $parseErrors | % {
                            Write-Output (New-Object -Type PSObject -Property @{
                                File = $relativeFileName
                                Error = $_.Message
                                Start = "$($_.Token.StartLine),$($_.Token.StartColumn)"
                                End = "$($_.Token.EndLine),$($_.Token.EndColumn)"
                                Content = $_.Token.Content
                            })
                        }
                    }
                }
                catch {
                    Write-Output (New-Object -Type PSObject -Property @{
                        File = $relativeFileName
                        Error = $_.Exception.Message
                    })
                }
            }
        }
    }
}
