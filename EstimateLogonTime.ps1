param([string]$logpath='.\')

$USER = $env:username.ToUpper()
$COMPUTER = $env:computername.ToUpper()
$Current_Time = Get-Date
$PCname = ''
$addedtime = 0

#1. get event time of last OS load
$filterXML = @'
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Kernel-General'] and (Level=4 or Level=0) and (EventID=12)]]</Select>
  </Query>
</QueryList>
'@
$OSLoadTime=(Get-WinEvent -ComputerName $PCname -MaxEvents 1 -FilterXml $filterXML).timecreated
#Write-Host $PCname
#Write-Host "1. Last System Boot @ " $OSLoadTime

#2. Get event time of Time-Service [pre-Ctrl+Alt-Del] after latest OS load
$filterXML = @'
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Time-Service'] and (Level=4 or Level=0) and (EventID=35)]]</Select>
  </Query>
</QueryList>
'@
$CtrlAltDelTime=(Get-WinEvent -ComputerName $PCname -MaxEvents 1 -FilterXml $filterXML).timecreated
#Write-Host "2. Time-sync after Boot @ " $CtrlAltDelTime
#get minutes (rounded to 1 decimal) between OS load time and 1st load of GPOs
$BootDuration = ((($CtrlAltDelTime - $OSLoadTime).TotalSeconds + $addedtime))

#3. get event time of 1st successful logon
$filterXML = @'
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Winlogon'] and (Level=4 or Level=0) and (EventID=7001)]]</Select>
  </Query>
</QueryList>
'@
$LogonDateTime=(Get-WinEvent -ComputerName $PCname -MaxEvents 1 -FilterXml $filterXML -ErrorAction SilentlyContinue).timecreated

If ($LogonDateTime) { 
    #Write-Host "3. Successful Logon @ " $LogonDateTime 
    } 
    Else {
    #Write-Host "Duration of Bootup = " $BootDuration "minutes" -foregroundcolor blue -BackgroundColor white
    #Write-Host $PCname "has not logged back in." -foregroundcolor red -BackgroundColor white
    Exit
    }
Write-Host "Duration of Bootup = " $BootDuration "minutes" -foregroundcolor blue -BackgroundColor white

#4. Get Win License validated after logon (about same time as explorer loads)
$filterXML = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[Provider[@Name='Microsoft-Windows-Winlogon'] and (Level=4 or Level=0) and (EventID=4101)]]</Select>
  </Query>
</QueryList>
'@
$DesktopTime=(Get-WinEvent -ComputerName $PCname -MaxEvents 1 -FilterXml $filterXML).timecreated
$LogonDuration = ((($DesktopTime - $LogonDateTime).TotalSeconds + $addedtime))
#Write-Host "4. WinLicVal after Logon @ " $DesktopTime
#Write-Host "Duration of Logon = " $LogonDuration "minutes" -foregroundcolor blue -BackgroundColor white

"Boottime;{0}" -f $BootDuration >> $logpath\EstimateLogonTime.txt
"LogonTime;{0}" -f $LogonDuration >> $logpath\EstimateLogonTime.txt
