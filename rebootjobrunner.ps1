#Set Presentation Mode
C:\Windows\System32\PresentationSettings.exe /start

#Get Controler Files
$controllerfile = "c:\tmp\control.txt" 
$logdirfile = "c:\tmp\logdirfile.txt"

$job = @(
	#Start
	"StartTestSuite.ps1",
	
	#Run GPUpdate
	"gpupdateprocesstime.ps1",
	
	#Run no reboot scripts
	"RunTests.ps1",
	
	#Run GPUpdate
	"gpupdateprocesstime.ps1",
	
	#Run BootPerfTests
	"BootPerfTest.ps1",
	"BootPerfTestCollection.ps1",
	
	#Reboot Test
	"RebootComputer.ps1",
	"EstimateLogonTime.ps1",
	"RebootComputer.ps1",
	"EstimateLogonTime.ps1",
	"RebootComputer.ps1",
	"EstimateLogonTime.ps1",
	
	#Run BootPerfTests
	"BootPerfTest.ps1",
	"BootPerfTestCollection.ps1",
	
	#Run GPUpdate
	"gpupdateprocesstime.ps1",
	
	#End
	"EndTestSuite.ps1"
)
$noofjobs = $job.Length

$step=0
If (Test-Path $controllerfile) {
	$stepStr =  Get-Content $controllerfile #TOINT
	$step = [int] $stepStr #XXX Error handling
}

while ($step -lt $noofjobs) {
	
	#Get the log dir
	$logdir = Get-Content $logdirfile
	
	#Increment and save step
	$step++
	"{0}" -f $step > $controllerfile
	
	#Do the Job
	$commandAppend = if($logdir){"-logpath $logdir"}
	$command = ".\{0} {1}" -f $job[$step-1], $commandAppend
	
	"{0}" -f $command
	
	Invoke-Expression $command
	
}


