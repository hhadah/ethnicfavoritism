* This is the Master File that
* runs all of the regressions
* and produces tables

clear
cls
eststo clear

global raw      "/Users/hhadah/Documents/GiT/ethnicfavoritism/data/raw"
global datasets "/Users/hhadah/Documents/GiT/ethnicfavoritism/data/datasets"
global RegressionResults "/Users/hhadah/Documents/GiT/ethnicfavoritism/output"
global LogFile "/Users/hhadah/Documents/GiT/ethnicfavoritism/logs"
global programs "/Users/hhadah/Documents/GiT/ethnicfavoritism/programs"

log using "$LogFile", replace

* Completed Primary School Script
do "$programs/07-Regressions_PrimComp.do"

* Infant Mortality Script
do "$programs/08-Regressions_infmort.do" 

* Electricity and water access script
do "$programs/09-Regressions_elec_wat.do"

* Wealth Script
do "$programs/10-Regressions_Wealth.do"

* Tables
// do "$programs/11-Regression_tables_graphs.do"

log close
clear
cls
