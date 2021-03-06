param([string] $filepath, [int]$numberofruns=1,[string]$logpath='.\')
$logprefix = 'OutlookStart'

if ((Test-Path $logpath) -eq $false) { Write-Warning "Logpath ($logpath) doesn't exist using current folder..." ; $logpath = '.\' }
$scriptstarttime = [DateTime]::Now
$filetime = $scriptstarttime.ToFileTime()
$logfile = "$logpath\${logprefix}_${filetime}.txt"

$scriptstarttime = [DateTime]::Now


"OutlookTest ($scriptstarttime)@($hostname)"
"OutlookTest ($scriptstarttime)@($hostname)" | Out-File $logfile

"testtype;timetaken;totaltimetaken" | Out-File $logfile -Append


$savearr = @()
for ($i = 1; $i -le $numberofruns; $i++)
   { 
        $start = [DateTime]::Now
    	#Insert Test Here!
	   
	    $outlook = new-object -com Outlook.Application

		#$Action = {Write-host "loaded!"}
		#Register-ObjectEvent -InputObject $outlook -EventName Quit -SourceIdentifier "quit" -Action $Action

		$namespace = $outlook.GetNamespace("MAPI")
		$folder = $namespace.GetDefaultFolder("olFolderInbox")
		$explorer = $folder.GetExplorer()
		$explorer.Display()	
		Start-Job {$namespace.SendAndReceive($true)}|Wait-Job
		$Outlook.Quit();
	   
	    Sleep -Seconds 10 
	   
        $end = [DateTime]::Now
        $diff = $end-$start
        $totaldiff = $end - $scriptstarttime
        $savearr += $diff
        "OpenAndSync;{0};{1}" -f [int]$diff.TotalMilliseconds,[int]$totaldiff.TotalMilliseconds
        "OpenAndSync;{0};{1}" -f [int]$diff.TotalMilliseconds,[int]$totaldiff.TotalMilliseconds | Out-File $logfile -Append
		
		Start-Process Outlook
		Sleep -Seconds 1
		$outlook = new-object -com Outlook.Application
		$Outlook.Quit();
		
		$end = [DateTime]::Now
        $diff = $end-$start
        $totaldiff = $end - $scriptstarttime
        $savearr += $diff
        "FullOpen;{0};{1}" -f [int]$diff.TotalMilliseconds,[int]$totaldiff.TotalMilliseconds
        "FullOpen;{0};{1}" -f [int]$diff.TotalMilliseconds,[int]$totaldiff.TotalMilliseconds | Out-File $logfile -Append
		
		Sleep -Seconds 20 
   }

$measure = $savearr | Measure-Object -Property TotalMilliseconds -Average -Maximum -Minimum
""
"Summary for save"
"Summary for save" | Out-File $logfile -Append
"count;average;maximum;minimum"
"count;average;maximum;minimum" | Out-File $logfile -Append
"{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum
"{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum | Out-File $logfile -Append
