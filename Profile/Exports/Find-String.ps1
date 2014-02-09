function Find-String {
    [CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$pattern,
		$path = $pwd,
		[switch]$regex,
		[switch]$showContext,
		[switch]$includeLargeFiles	
    )

	$maxFileSizeToSearchInBytes = 1024*1024 # 1mb
	$liesOfContext = 2

	$priorPath = ""

	$global:T = Get-ChildItem -Path $path -Recurse | 
		? { $_.PSIsContainer -eq $false -and ($includeLargeFiles -or $_.Length -le $maxFileSizeToSearchInBytes) } | 
		Select-String -Pattern $pattern -AllMatches -SimpleMatch:$(!$regex) -Context $liesOfContext #|
# 		% {
# 	        if ($priorPath -ne $_.Path) {
#             	Write-Host ("`n{0}" -f $_.RelativePath($path)) -foregroundColor Green
#             	$priorPath = $_.Path
#         	} elseif ($showContext) {
#                 Write-Host "--"
#         	}

#             if ($showContext -and $_.Context.DisplayPreContext) {
#             	$lines = ($_.LineNumber - $_.Context.DisplayPreContext.Length)..($_.LineNumber - 1)
#         		for ($i = 0; $i -lt $_.Context.DisplayPreContext.length; $i++) {
#         			Write-Host ("{0}: {1}" -f $lines[$i], $_.Context.DisplayPreContext[$i])
#         		}
#             }
# $global:t += $_
#             Write-Host ("{0}: " -f $_.LineNumber) -NoNewLine
#             $index = 0
#             foreach ($match in $_.Matches) {
#                 #Write-Host $_.Line.SubString($index, $match.Index - $index) -NoNewLine
#                 #Write-Host $match.Value -ForegroundColor Black -BackgroundColor Yellow -NoNewLine
#                 $index = $match.Index + $match.Length
#             }
#             Write-Host $_.Line.SubString($index) 

# 			if ($showContext -and $_.Context.DisplayPostContext) {
# 				$lines = ($_.LineNumber + 1)..($_.LineNumber + $_.Context.DisplayPostContext.Length)
# 	        	for ($i = 0; $i -lt $_.Context.DisplayPostContext.length; $i++) {
# 	        		Write-Host ("{0}: {1}" -f $lines[$i], $_.Context.DisplayPostContext[$i])
# 	        	}
# 	  		}
# 	  	}
}
@{Function = "Find-String"}

#http://mohundro.com/blog/2009/06/12/find-stringps1---ack-for-powershell/
#https://github.com/drmohundro/Find-String/blob/master/Find-String.psm1
#http://answers.oreilly.com/topic/1989-how-to-search-a-file-for-text-or-a-pattern-in-windows-powershell/