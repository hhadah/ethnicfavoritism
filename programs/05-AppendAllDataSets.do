/*
Append all data setts
*/

clear
cls

* Open Primary school dataset
use "$raw/DHS_PrimSchl.dta"

* append with electrification and water
append using "$raw/DHS_ElectrificationWater.dta", force

* append using Wealth
append using "$raw/DHS_Wealth.dta", force

* append with children recode
append using "$raw/DHS_Infantdata_polity_coethnic.dta", force

* save new data set
save "$datasets/DHS_AppendedDataSet.dta", replace

