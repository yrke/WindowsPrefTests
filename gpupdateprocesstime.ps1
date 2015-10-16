param([string]$logpath='.\')

$start = [DateTime]::Now
cmd /c "echo n | gpupdate /force /wait:-1  /Target:User"
$end = [DateTime]::Now
$diff = $end-$start
"UserPolicyTime;{0}" -f $diff >> $logpath\gpupdateprocesstime.txt

$start = [DateTime]::Now
cmd /c "echo n | gpupdate /force /wait:-1  /Target:Computer"
$end = [DateTime]::Now
$diff = $end-$start
"ComputerPolicyTime;{0}" -f $diff >> $logpath\gpupdateprocesstime.txt
