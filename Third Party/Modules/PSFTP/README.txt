Import-Module PSFTP 
Set-FTPConnection -Credentials mgajda -Server ftp://ftp.server.org -Session MyTestSession -UsePassive 
$Session = Get-FTPConnection -Session MyTestSession 
 
New-FTPItem -Session $Session -Name TestRootDir 
New-FTPItem -Session $Session -Name TestDir1 -Path /TestRootDir 
New-FTPItem -Session $Session -Name TestDir2 -Path /TestRootDir 
New-FTPItem -Session $Session -Name TestDir11 -Path /TestRootDir/TestDir1 
 
Get-FTPChildItem -Session $Session -Path /TestRootDir -Recurse -Depth 2 
 
"Test File" | Out-File TestFile.txt 
Get-ChildItem TestFile.txt | Add-FTPItem -Session $Session -Path /TestRootDir 
Get-ChildItem TestFile.txt | Add-FTPItem -Session $Session -Path /TestRootDir -Overwrite 
Get-ChildItem TestFile.txt | Add-FTPItem -Session $Session -Path /TestRootDir/TestDir1  
Get-ChildItem TestFile.txt | Add-FTPItem -Session $Session -Path /TestRootDir/TestDir2 -BufferSize 5 
Add-FTPItem -Session $Session -Path /TestRootDir/TestDir1/TestDir11 -LocalPath TestFile.txt 
 
Get-FTPChildItem -Session $Session -Path /TestRootDir -Recurse -Depth 2 
Get-FTPChildItem -Session $Session -Path /TestRootDir -Recurse 
 
Get-FTPItemSize -Session $Session -Path /TestRootDir/TestDir1/TestFile.txt 
 
Rename-FTPItem -Session $Session -Path /TestRootDir/TestDir1/TestFile.txt -NewName TestFile2.txt 
Rename-FTPItem -Session $Session -Path /TestRootDir/TestDir1/TestFile2.txt -NewName ../TestFile2.txt 
 
Get-FTPChildItem -Session $Session -Path /TestRootDir | Get-FTPItem -Session $Session -LocalPath C:\test 
Get-FTPChildItem -Session $Session -Path /TestRootDir -Recurse | Get-FTPItem -Session $Session -LocalPath C:\test -RecreateFolders 
 
Get-FTPChildItem -Session $Session -Path /TestRootDir -Filter TestF* | Remove-FTPItem -Session $Session 
Remove-FTPItem -Session $Session -Path /TestRootDir -Recurse 