function Invoke-Installer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$Name,
        [Parameter(Mandatory=$true)]$Uri,
        [Parameter(Mandatory=$true)][ValidateSet("msi", "exe")]$Type,
        $ArgumentList,
        [switch]$Zipped,
        [switch]$Optional
    )
    
    $installer = [System.IO.Path]::ChangeExtension([System.IO.Path]::GetTempFileName(), $Type)
    Write-Host -NoNewLine "Downloading $Name... "
    Invoke-WebRequest -Uri $Uri -OutFile $installer
    Write-Host -ForegroundColor Green "Done."
    
    if ($Zipped) {
        Write-Host -NoNewLine "Unzipping $Name... "
        
        Add-Type -AssemblyName "System.IO.Compression.FileSystem"
        
        $zipFile = $installer
        
        $unzipDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetFileNameWithoutExtension([System.IO.Path]::GetRandomFileName()))
        New-Item -ItemType Directory -Force -Path $unzipDirectory

        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile, $unzipDirectory)
        Get-ChildItem -Path $unzipDirectory -File -Filter "*.exe" -OutVariable installer | Measure-Object -Line | ? Lines -gt 1 | % { throw "Found more than one executable in the unzipped instal package" }
        $installer = $installer.FullName
        
        Write-Host -ForegroundColor Green "Done."
    }
    
    Write-Host -NoNewLine "Installing $Name... "
    switch ($Type)
    {
        "msi" {
            $installationProcess = Start-Process -FilePath "msiexec.exe" -Wait -PassThru -ArgumentList  @("/i", "`"$installer`"", "/qb", "/norestart")
        }
        "exe" {
            $installationProcess = Start-Process -FilePath $installer -Wait -PassThru -ArgumentList $ArgumentList
        }
    }
    
    Remove-Item -Path $installer -Force 
    if ($Zipped) {
        Remove-Item -Path $unzipDirectory -Force -Recurse
        Remove-Item -Path $zipFile -Force
    }
    
    if ($installationProcess.ExitCode -eq 0) {
        Write-Host -ForegroundColor Green "Done."
        return $true
    } elseif ($Optional) {
        Write-Host -ForegroundColor Yellow "Failed!"
        return $true
    } else {
        Write-Host -ForegroundColor Red "Fatal failure!"
        return $false
    }
}
