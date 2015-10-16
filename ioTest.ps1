#
# Expects Diskspd to be present and unpacked in the script directory ($pwd)
#
param([string]$filepath,[int]$numberofruns=2,[string]$logpath='.\')
$logprefix = 'ioTest'
$diskspdtopfolder = $pwd.Path + '\Diskspd-v2.0.12'

if ($filepath -eq "") {
  "Usage: ioTest.ps1 <filepath> [numberofruns] [logpath]"
#  $filepath = 'c:\_misc\test.docx'
  $filepath = '\\its.aau.dk\Fileshares\infrastruktur\TeamArkitektOgProjektledere\bk\testfile.dat'
}

if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
  $diskspd = "$diskspdtopfolder\amd64fre\diskspd.exe"
} else {
  $diskspd = "$diskspdtopfolder\x86fre\diskspd.exe"
}

if ((Test-Path $logpath) -eq $false) { Write-Warning "Logpath ($logpath) doesn't exist using current folder..." ; $logpath = '.\' }

$scriptstarttime = [DateTime]::Now
$logfile = $logpath + "\" + $logprefix + "_" + $scriptstarttime.ToFileTime() + ".txt"
$summarylogfile = $logpath + "\" + $logprefix + "_Summary_" + $scriptstarttime.ToFileTime() + ".txt"
$hostname = (hostname)

"ioTest ($scriptstarttime)@($hostname)"
"ioTest ($scriptstarttime)@($hostname)" | Out-File $logfile
"ioTestSummary ($scriptstarttime)@($hostname)" | Out-File $summarylogfile
"Filepath: $filepath"
"Filepath: $filepath" | Out-File $logfile -Append
"Filepath: $filepath" | Out-File $summarylogfile -Append

#There is some strange problem with the following - latency not measured and unresonable results
Function ioTestHelper($params,$description) {
Trap{"ERROR - DO NOT USE!"}
Exit
    #We're getting errors from diskspd if we don't run as administrator
    #This results in some ugly red messages which we remove by setting the EA globally to SC
#    $ErrorActionPreference = "SilentlyContinue"

    $res = &$diskspd -c1G $params $filepath
    $res | Out-File $logfile -Append
    foreach ($line in $res) {if ($line -like "total:*") { $total=$line; break } }
    foreach ($line in $res) {if ($line -like "avg.*") { $avg=$line; break } }
    $mbps = $total.Split("|")[2].Trim() 
    $iops = $total.Split("|")[3].Trim()
    $latency = $total.Split("|")[4].Trim()
    $cpu = $avg.Split("|")[1].Trim().Trim('%')
    Return "$description;$iops;$mbps;$latency;$cpu"
}

Function ioTestHelper2($params,$description) {
    #We're getting errors from diskspd if we don't run as administrator
    #This results in some ugly red messages which we remove by setting the EA globally to SC
    $ErrorActionPreference = "SilentlyContinue"

    $cmd = "$diskspd -c1G $params $filepath"
    $res = cmd /C $cmd
    $res | Out-File $logfile -Append
    foreach ($line in $res) {if ($line -like "total:*") { $total=$line; break } }
    foreach ($line in $res) {if ($line -like "avg.*") { $avg=$line; break } }
    $mbps = $total.Split("|")[2].Trim() 
    $iops = $total.Split("|")[3].Trim()
    $latency = $total.Split("|")[4].Trim()
    $cpu = $avg.Split("|")[1].Trim().Trim('%')
    Return "$description;$iops;$mbps;$latency;$cpu"
}

###Main script
"testdescription;iops;MBps;latency;cpu;testtime;runnumber"
"testdescription;iops;MBps;latency;cpu;testtime;runnumber" | Out-File $summarylogfile -Append
for ($i = 1; $i -le $numberofruns; $i++) {
    ###Read###
    #Testing Read for small random without HW acceleration
    $res = ioTestHelper2 "-b4K -r -w0 -d10 -L -h" "SmallRandomReadNoHW"
    $res += ";" + [DateTime]::Now.ToLongTimeString() + ";$i"
    $res
    $res | Out-File $summarylogfile -Append

    #Testing Read for large sequential without HW acceleration
    $res = ioTestHelper2 "-b512K -w0 -d10 -L -h" "LargeSequentialReadNoHW"
    $res += ";" + [DateTime]::Now.ToLongTimeString() + ";$i"
    $res
    $res | Out-File $summarylogfile -Append

    ###Write###
    #Testing Write for small random without HW acceleration
    $res = ioTestHelper2 "-b4K -r -w100 -d10 -L -h" "SmallRandomWriteNoHW"
    $res += ";" + [DateTime]::Now.ToLongTimeString() + ";$i"
    $res
    $res | Out-File $summarylogfile -Append

    #Testing Write for large sequential without HW acceleration
    $res = ioTestHelper2 "-b512K -w100 -d10 -L -h" "LargeSequentialWriteNoHW"
    $res += ";" + [DateTime]::Now.ToLongTimeString() + ";$i"
    $res
    $res | Out-File $summarylogfile -Append

    ###70Read30Write###
    #Testing ReadWrite for small random without HW acceleration
    $res = ioTestHelper2 "-b4K -r -w30 -d10 -L -h" "SmallRandomReadWriteNoHW"
    $res += ";" + [DateTime]::Now.ToLongTimeString() + ";$i"
    $res
    $res | Out-File $summarylogfile -Append

    #Testing ReadWrite for large sequential without HW acceleration
    $res = ioTestHelper2 "-b512K -w30 -d10 -L -h" "LargeSequentialReadWriteNoHW"
    $res += ";" + [DateTime]::Now.ToLongTimeString() + ";$i"
    $res
    $res | Out-File $summarylogfile -Append
}

$scriptendtime = [DateTime]::Now
"Scripttimetaken: {0}" -f ($scriptendtime-$scriptstarttime).TotalMilliseconds
