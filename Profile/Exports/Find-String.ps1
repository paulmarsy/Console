
function Find-String {
    [CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$pattern,
		$path = $pwd,
		[switch]$showContext,
		[switch]$includeLargeFiles
    )

	$maxFileSizeToSearchInBytes = 1024*1024 # 1mb
	
	Write-Host "Finding '$pattern' in $path...`n" -ForegroundColor White
	Get-ChildItem -Path $path -Recurse | 
		? { $_.PSIsContainer -eq $false -and ($includeLargeFiles -or $_.Length -le $maxFileSizeToSearchInBytes) } | 
		Select-String -Pattern ([Regex]::Escape($pattern)) -AllMatches -Context 2 |
		Group-Object -Property Path |
		% {
			Write-Host (Resolve-Path -Relative $_.Name) -ForegroundColor Cyan -NoNewLine
			Write-Host ":"

			$_.Group | % {
		     	# Display pre-context
	            if ($showContext -and $_.Context.DisplayPreContext) {
	            	$lines = ($_.LineNumber - $_.Context.DisplayPreContext.Length)..($_.LineNumber - 1)
	        		for ($i = 0; $i -lt $_.Context.DisplayPreContext.length; $i++) {
	        			Write-Host ("{0}: {1}" -f $lines[$i], $_.Context.DisplayPreContext[$i]) -ForegroundColor DarkGray
	        		}
	            }

	            # Display main result
	            Write-Host ("{0}: " -f $_.LineNumber) -NoNewLine
	            $index = 0
	            foreach ($match in $_.Matches) {
	                Write-Host $_.Line.SubString($index, $match.Index - $index) -NoNewLine
	                Write-Host $match.Value -ForegroundColor Black -BackgroundColor Yellow -NoNewLine
	                $index = $match.Index + $match.Length
	            }
	            Write-Host $_.Line.SubString($index)

	            # Display post-context
				if ($showContext -and $_.Context.DisplayPostContext) {
					$lines = ($_.LineNumber + 1)..($_.LineNumber + $_.Context.DisplayPostContext.Length)
		        	for ($i = 0; $i -lt $_.Context.DisplayPostContext.length; $i++) {
		        		Write-Host ("{0}: {1}" -f $lines[$i], $_.Context.DisplayPostContext[$i]) -ForegroundColor DarkGray
		        	}
		  		}

		  		if ($showContext) {
		  			Write-Host "--"
		  		}
		  	}
	  	}
}
@{Function = "Find-String"}

#http://mohundro.com/blog/2009/06/12/find-stringps1---ack-for-powershell/
#https://github.com/drmohundro/Find-String/blob/master/Find-String.psm1
#http://answers.oreilly.com/topic/1989-how-to-search-a-file-for-text-or-a-pattern-in-windows-powershell/