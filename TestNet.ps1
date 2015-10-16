param([string]$logpath='.\')

if ((Test-Path $logpath) -eq $false) { Write-Warning "Logpath ($logpath) doesn't exist using current folder..." ; $logpath = '.\' }

$logprefix = 'testNet'

$scriptstarttime = [DateTime]::Now
$hostname = (hostname)
$logfile = $logpath + "\" + $logprefix + "_" + $scriptstarttime.ToFiletime() + ".txt"
$resfile = $logpath + "\" + $logprefix + "_res_" + $scriptstarttime.ToFiletime() + ".csv"

$res = ipconfig /all
"testNet ($scriptstarttime)@($hostname)"
"testNet ($scriptstarttime)@($hostname)" | Out-File $logfile
$res | Out-File $logfile -Append

Function NetTest([string] $dst, [int] $tcpport) {
  $route = (Test-NetConnection $dst -TraceRoute).TraceRoute
  $tcptest = Test-NetConnection $dst -Port $tcpport
  $tcptest | Select-Object ComputerName,RemoteAddress,PingSucceeded,@{Name="PingRoundtripTime";Expression={$_.PingReplyDetails.RoundtripTime}},TcpTestSucceeded,RemotePort,InterfaceAlias,InterfaceDescription,NetworkIsolationContext,@{Name="Traceroute";Expression={$route}} | Export-Csv $resfile -UseCulture -Append
}

NetTest srv-dc01.srv.aau.dk 445
NetTest srv-dc01.srv.aau.dk 389
NetTest srv-dc01.srv.aau.dk 3268
NetTest srv-dc01.srv.aau.dk 3389

NetTest srv-dc02.srv.aau.dk 445
NetTest srv-dc02.srv.aau.dk 389
NetTest srv-dc02.srv.aau.dk 3268
NetTest srv-dc02.srv.aau.dk 3389

NetTest its-dc01.its.aau.dk 445
NetTest its-dc01.its.aau.dk 389
NetTest its-dc01.its.aau.dk 3268
NetTest its-dc01.its.aau.dk 3389

NetTest its-dc02.its.aau.dk 445
NetTest its-dc02.its.aau.dk 389
NetTest its-dc02.its.aau.dk 3268
NetTest its-dc02.its.aau.dk 3389

NetTest ad-rodc01.aau.dk 445
NetTest ad-rodc01.aau.dk 389
NetTest ad-rodc01.aau.dk 3268
NetTest ad-rodc01.aau.dk 3389

NetTest ad-rodc02.aau.dk 445
NetTest ad-rodc02.aau.dk 389
NetTest ad-rodc02.aau.dk 3268
NetTest ad-rodc02.aau.dk 3389

NetTest ad-rodc03.aau.dk 445
NetTest ad-rodc03.aau.dk 389
NetTest ad-rodc03.aau.dk 3268
NetTest ad-rodc03.aau.dk 3389

NetTest ad-rodc04.aau.dk 445
NetTest ad-rodc04.aau.dk 389
NetTest ad-rodc04.aau.dk 3268
NetTest ad-rodc04.aau.dk 3389

NetTest its-fs.srv.aau.dk 445
