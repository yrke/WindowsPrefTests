param([string]$logpath='.\')
	
$controllerfile = "c:\tmp\control.txt" 
$logdirfile = "c:\tmp\logdirfile.txt"

Copy-Item $logpath "\\admt-fs01.admt.aau.dk\tests\Results\" -recurse	
Remove-Item  $logpath -Recurse
	
"0" > $controllerfile
"" > $logdirfile
		
Write-Host "Test has finished, and test results are uploaded to result fileshare"
Write-Host "Press [Enter] to shutdown computer"
Read-Host
	
Stop-Computer