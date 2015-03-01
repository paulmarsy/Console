function Clear-FolderHandles
{ 
    param(
        [Parameter(Mandatory=$true)]$Folder
    )

    if (-not $ProfileConfig.General.IsAdmin) {
        throw "You must be running as an Administrator to remove file handles"
    }

    if (-not (Get-Command -Name "handle.exe" -CommandType Application -ErrorAction Ignore)) {
        throw "Unable to find handle.exe in the PATH"
    }

    if (-not (Test-Path $Folder)) {
        throw "$Folder does not exist"
    }

    # Create Tools directory, if it doesn't already exist 
    Write-Host "Dropping locks on folder: $pathToFree"

    if (!(Test-Path -Path $toolsDir)) 
    { 
        Write-Host "Creating ToolsDirectory at $toolsDir" 
        New-Item -ItemType directory -Path $pathToFree 
    } 
      
    # Extract Handle.exe, if we don't already have it 
    $handleExPath = "$toolsDir\handle.exe" 
    InstallOnAccess-HandleEx($handleExPath)

    $results = &("$handleExPath") 
    #$results = Start-Process -FilePath $handleExPath -Wait 
    $handles = $results | where { $_ -match "File" -and $_ -match $pathToFree } 
    $handles = $handles | foreach  ` 
    { 
        $handle = $_.Substring(0, $_.IndexOf(':')).Trim();

        Write-Host "Closing handle: $handle" 
        & handle -c $handle 
    }        
}