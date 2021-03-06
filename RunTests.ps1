param([string]$logpath='.\')

$testfolder = $logpath

$wfstestfile = '\\admt-fs01.admt.aau.dk\tests\test.xlsx'
$wfsiotestfile = '\\admt-fs01.admt.aau.dk\tests\testfile.dat'

$testfile = '\\its.aau.dk\Fileshares\infrastruktur\TeamArkitektOgProjektledere\bk\test.xlsx'
$iotestfile = '\\its.aau.dk\Fileshares\infrastruktur\TeamArkitektOgProjektledere\bk\testfile.dat'

#Start standard tests
.\GetBasicInfo.ps1 -logpath $testfolder
.\FileCopyTest.ps1 -filepath $testfile -numberofruns 200 -logpath $testfolder
.\ExcelTest.ps1 -filepath $testfile -numberofruns 200 -logpath $testfolder
.\ioTest.ps1 -filepath $iotestfile -numberofruns 2 -logpath $testfolder
.\TestNet.ps1 -logpath $testfolder

#Test agains a windows fileserver...
.\FileCopyTest.ps1 -filepath $wfstestfile -numberofruns 200 -logpath $testfolder
.\ExcelTest.ps1 -filepath $wfstestfile -numberofruns 200 -logpath $testfolder
.\ioTest.ps1 -filepath $wfsiotestfile -numberofruns 2 -logpath $testfolder

#Then with the Users document folder...
$userpath = "\\" + $env:USERDNSDOMAIN + "\Users\" + $env:USERNAME + "\Documents"
Copy-Item $wfstestfile $userpath
$usertestfile = "$userpath\test.xlsx"
$useriotestfile = "$userpath\testfile.dat"
.\FileCopyTest.ps1 -filepath $usertestfile -numberofruns 200 -logpath $testfolder
.\ExcelTest.ps1 -filepath $usertestfile -numberofruns 200 -logpath $testfolder
.\ioTest.ps1 -filepath $useriotestfile -numberofruns 2 -logpath $testfolder
#Cleanup after testfiles...
If (Test-Path $usertestfile) { Remove-Item $usertestfile }
If (Test-Path $useriotestfile) { Remove-Item $useriotestfile }

#Test Outlook
.\OutlookTest.ps1 -numberofruns 10 -logpath $testfolder

