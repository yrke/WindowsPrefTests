param([string] $filepath, [int] $numberofruns=50,[string]$logpath='.\')
$logprefix = 'ExcelTest'

if ($filepath -eq "") {
  "Usage: ExcelTest.ps1 <filepath> [numberofruns] [logpath]"
#  $filepath = 'c:\_misc\test.docx'
  $filepath = '\\its.aau.dk\Fileshares\infrastruktur\TeamArkitektOgProjektledere\bk\test.xlsx'
}

if ((Test-Path $logpath) -eq $false) { Write-Warning "Logpath ($logpath) doesn't exist using current folder..." ; $logpath = '.\' }

$objFile = Get-Item $filepath
$scriptstarttime = [DateTime]::Now
$logfile = $logpath + "\" + $logprefix + "_" + $scriptstarttime.ToFileTime() + ".txt"
$hostname = (hostname)

"Exceltest ($scriptstarttime)@($hostname)"
"Exceltest ($scriptstarttime)@($hostname)" | Out-File $logfile
"Filepath: $filepath"
"Filepath: $filepath" | Out-File $logfile -Append
"Filesize: {0}" -f $objFile.Length
"Filesize: {0}" -f $objFile.Length | Out-File $logfile -Append
"testtype;timetaken;totaltimetaken;testtime;runnumber"
"testtype;timetaken;totaltimetaken;testtime;runnumber" | Out-File $logfile -Append

$start = [DateTime]::Now
$objExcel = New-Object -ComObject Excel.Application
$objExcel.Visible = $true
$objWorkbook = $objExcel.Workbooks.Open($filepath)
$end = [DateTime]::Now
$diff = $end-$start

"open;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]($end-$scriptstarttime).TotalMilliseconds,$start.ToLongTimeString(),0
"open;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]($end-$scriptstarttime).TotalMilliseconds,$start.ToLongTimeString(),0 | Out-File $logfile -Append

$savearr = @()
for ($i = 1; $i -le $numberofruns; $i++)
   { 
       $start = [DateTime]::Now
       $res = $objWorkbook.Save()
       $end = [DateTime]::Now
       $diff = $end-$start
       $totaldiff = $end - $scriptstarttime
       $savearr += $diff
       "save;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]$totaldiff.TotalMilliseconds,$start.ToLongTimeString(),$i
       "save;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]$totaldiff.TotalMilliseconds,$start.ToLongTimeString(),$i | Out-File $logfile -Append
   }

$measure = $savearr | Measure-Object -Property TotalMilliseconds -Average -Maximum -Minimum
""
"Summary for save"
"Summary for save" | Out-File $logfile -Append
"count;average;maximum;minimum"
"count;average;maximum;minimum" | Out-File $logfile -Append
"{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum
"{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum | Out-File $logfile -Append

$objExcel.Quit()