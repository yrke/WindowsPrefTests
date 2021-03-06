param([string]$logpath='.\')

if ((Test-Path $logpath) -eq $false) { Write-Warning "Logpath ($logpath) doesn't exist using current folder..." ; $logpath = '.\' }

Wait-Process -Name WPRUI -ErrorAction SilentlyContinue

#Logfiles are formatted as: <hostname>.<datetime>.boot<nb>.etl
#$hostname = (hostname)

#Default logpath...
#$etllogpath = ".\"
#$etllogpath = $env:windir + "\system32"

#if ($etllogpath -ne $logpath) {
#  Copy-Item "$etllogpath\$hostname*.etl" $logpath
#  Remove-Item  "$etllogpath\$hostname*.etl"
#}
