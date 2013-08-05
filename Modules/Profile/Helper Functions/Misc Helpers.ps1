param($InstallPath)

Set-Alias browse Show-Location
function Show-Location {
    [CmdletBinding()]
	param(
		[ValidateSet("CurrentDirectory", "InstallPath", "Documents")]
        $location = "CurrentDirectory"
    )
    
	$switch = switch ($location)
    {
        "CurrentDirectory" { "." }
        "InstallPath" { "$InstallPath" }
        "Documents" { "/n" }
    }
	& explorer $switch
}

function Get-Type {
    [CmdletBinding()]
	param(  
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
		$obj
    )
    
    process {
		$obj | ? { $null -ne $_ } | % { $_.GetType() }
    }
}

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


Set-Alias remote Run-Remote
function Run-Remote {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $ComputerName,
        [Parameter(ValueFromRemainingArguments=$true)]
        $command
    )

    if ($command) { 
        $psexecOutput = [IO.Path]::GetTempFileName()
        Write-Verbose "PsExec Output: $psexecOutput"

        $existingCommand = Invoke-Command -ComputerName $ComputerName { Get-Command -Name $command -CommandType Application }

        if ($null -ne $existingCommand) {
            & PsExec.exe -acceptEula \\$ComputerName $command 2>$psexecOutput
        }
        else {
            & PsExec.exe -acceptEula \\$ComputerName -c $command 2>$psexecOutput
        }


        Get-Content $psexecOutput | Select-Object -Last 3 | Select-Object -First 2
        if (-not $PSBoundParameters['Verbose']) {
            Remove-Item $psexecOutput -Force
        }
    }
    else {
        Enter-PSSession -ComputerName $ComputerName
    }
}