param([string]$logpath='.\')

if ((Test-Path $logpath) -eq $false) { Write-Warning "Logpath ($logpath) doesn't exist using current folder..." ; $logpath = '.\' }

"Getting systeminfo..."
systeminfo > "$logpath\systeminfo.txt"

"Getting ipconfig..."
ipconfig /all > "$logpath\ipconfig.txt"
