* This is the Master File that
* runs all of the regressions
* and produces tables

clear
cls
eststo clear

log using "$LogFile", replace

* Completed Primary School Script
do "$SchoolScript"

* Infant Mortality Script
do "$MortScript" 

* Electricity and water access script
do "$ElecWaterScript"

* Wealth Script
do "$WealthScript"

* Tables
do "$TablesScript"

log close
clear
cls
