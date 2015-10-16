param([string]$logpath='.\',[int]$numiterations=1)

# Requires that Windows ADK is installed - Kun "Windows Performance Toolkit" er nødvendig!
# Also requires run as administrator (or UAC disabled)
# Also needs: wpr -DisablePagingExecutive on


cd $logpath;
wpr -start GeneralProfile -onoffscenario boot -numiterations $numiterations


Sleep -Seconds 30