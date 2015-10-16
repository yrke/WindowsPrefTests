param([string] $filepath, [int]$numberofruns=100,[string]$logpath='.\')
$logprefix = 'FileCopyTest'

if ($filepath -eq "") {
  "Usage: FileCopyTest.ps1 <filepath> [numberofruns] [logpath]"
#  $filepath = 'c:\_misc\test.docx'
  $filepath = '\\its.aau.dk\Fileshares\infrastruktur\TeamArkitektOgProjektledere\bk\test.xlsx'
}

if ((Test-Path $logpath) -eq $false) { Write-Warning "Logpath ($logpath) doesn't exist using current folder..." ; $logpath = '.\' }

$scriptstarttime = [DateTime]::Now
$filetime = $scriptstarttime.ToFileTime()
$logfile = "$logpath\${logprefix}_${filetime}.txt"

$dstfolder = (Get-Item env:tmp).Value
$srcObj = Get-Item $filepath

$filename = $srcObj.Name
$dst = "$dstfolder\" + $filename
$copyarr = @()
$copybackarr = @()

"FileCopyTest ({0})@({1})" -f $scriptstarttime,(hostname)
"FileCopyTest ({0})@({1})" -f $scriptstarttime,(hostname) | Out-File $logfile
"SrcPath: {0}" -f $srcObj.FullName
"SrcPath: {0}" -f $srcObj.FullName | Out-File $logfile -Append
"DstPath: {0}" -f $dst
"DstPath: {0}" -f $dst | Out-File $logfile -Append
"Filesize: {0}" -f $srcObj.Length
"Filesize: {0}" -f $srcObj.Length | Out-File $logfile -Append
""
"copydirection;timetaken;totaltimetaken;testtime;runnumber"
"copydirection;timetaken;totaltimetaken;testtime;runnumber" | Out-File $logfile -Append 
for ($i = 1; $i -le $numberofruns; $i++) {
#  "Copy..."
  $start = [DateTime]::Now
  $res = $srcObj.CopyTo($dst,$true)
  $end = [DateTime]::Now
  $diff = $end-$start
  $copyarr += $diff
  "src-dst;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]($end-$scriptstarttime).TotalMilliseconds,$start.ToLongTimeString(),$i
  "src-dst;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]($end-$scriptstarttime).TotalMilliseconds,$start.ToLongTimeString(),$i | Out-File $logfile -Append

#  "CopyBack..."
  if (Test-Path $dst) {
    $dstObj = Get-Item $dst
    $start = [DateTime]::Now
    $res = $dstObj.CopyTo($srcObj.FullName,$true)
    $end = [DateTime]::Now
    $diff = $end-$start
    $copybackarr += $diff
    "dst-src;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]($end-$scriptstarttime).TotalMilliseconds,$start.ToLongTimeString(),$i
    "dst-src;{0};{1};{2};{3}" -f [int]$diff.TotalMilliseconds,[int]($end-$scriptstarttime).TotalMilliseconds,$start.ToLongTimeString(),$i | Out-File $logfile -Append
  }
}

""
"Statistics..."
"Statistics..." | Out-File $logfile -Append
"copydirection;count;average;maximum;minimum"
"copydirection;count;average;maximum;minimum" | Out-File $logfile -Append
$measure = $copyarr | Measure-Object -Property TotalMilliseconds -Average -Maximum -Minimum
"src-dst;{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum
"src-dst;{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum | Out-File $logfile -Append
$measure = $copybackarr | Measure-Object -Property Milliseconds -Average -Maximum -Minimum
"dst-src;{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum
"dst-src;{0};{1};{2};{3}" -f [int]$measure.Count,[int]$measure.Average,[int]$measure.Maximum,[int]$measure.Minimum | Out-File $logfile -Append
