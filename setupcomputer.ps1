#c:\tmp\datafiles

$username = "demouser"
$domain = "its"
$password = "hfy/ffe3"



$controllerfile = "c:\tmp\control.txt" 
$logdirfile = "c:\tmp\logdirfile.txt"

#Create Control Files
"0" > $controllerfile
"" > $logdirfile

#Setup Auto Logon 
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Value "$domain\$username" -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Value $password -Force

#Setup Scheduled task to run tests (run as admin) (what account does it run as?)
#schtasks /Create $datadir\StartScriptTask.xml /TN StartTestScript 
#Copy bat file to run from task

wpr -DisablePagingExecutive on

Restart-Computer

#Reboot
#reboot /r /t 30  //Not workin!