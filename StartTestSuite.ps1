param([string]$logpath='.\')

$logdirfile = "c:\tmp\logdirfile.txt"

#Get Computer Name
$computername = [System.Net.Dns]::GetHostName()

#Get IP Address
$StringIP = "None"
		
$CurrentIPs = @(); 

#Get the IP Adressen of interfaces
$IPs = Get-WmiObject -query "select * from Win32_NetworkAdapterConfiguration where IPEnabled = $true" | %{$_.IPaddress -notmatch 'fe80'}
if ($IPs -ge 1) { 
	$StringIP=([string]::Join("-",$IPs))
}else {
	$StringIP=$IPs
}
$StringIP=$StringIP.Replace(":","+")	 #Normalize IPv6 adresses (cant use : in path)
		
#Generate Test Folder Name
$testfolderprefix = "TimingTests_{0}_{1}" -f $computername, $StringIP

$scriptstarttime = [DateTime]::Now
$testfolder = "..\" + $testfolderprefix + "_" + $scriptstarttime.ToFileTime()

#Create the tmp file with the logdir name
"{0}" -f $testfolder > $logdirfile	

#Create the folder
$res = New-Item -Path $testfolder -ItemType Directory