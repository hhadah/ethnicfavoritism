/*
This do file is to append
the data from the women and
men recodes.
*/
********************************************************************************
cls
clear
********************************************************************************
* Open Women recode
use "$raw/WomenRecode.dta"
********************************************************************************
* Append Women and Men recodes
append using "$raw/MenRecodeVarMatched.dta", force
********************************************************************************
* Fix interview year for Ethiopia
replace intyear = 2001 & monthint == 12 if intyear_et == 1992 & monthint_et == 5
replace intyear = 2000 & monthint == 1 if intyear_et == 1992 & monthint_et == 4
replace intyear = 2000 & monthint == 2 if intyear_et == 1992 & monthint_et == 6
replace intyear = 2000 & monthint == 4 if intyear_et == 1992 & monthint_et == 8
replace intyear = 2001 & monthint == 5 if intyear_et == 1992 & monthint_et == 9
replace intyear = 2001 & monthint == 6 if intyear_et == 1992 & monthint_et == 10
replace intyear = 2001 & monthint == 7 if intyear_et == 1992 & monthint_et == 11
replace intyear = 2001 & monthint == 8 if intyear_et == 1992 & monthint_et == 12
replace intyear = 2001 & monthint == 8 if intyear_et == 1992 & monthint_et == 12
replace intyear = 2001 & monthint == 9 if intyear_et == 1992 & monthint_et == 1
replace intyear = 2001 & monthint == 10 if intyear_et == 1992 & monthint_et == 2
replace intyear = 2001 & monthint == 12 if intyear_et == 1992 & monthint_et == 3

replace intyear = 2005 & monthint == 12 if intyear_et == 1997 & monthint_et == 5
replace intyear = 2004 & monthint == 1 if intyear_et == 1997 & monthint_et == 4
replace intyear = 2004 & monthint == 2 if intyear_et == 1997 & monthint_et == 6
replace intyear = 2004 & monthint == 4 if intyear_et == 1997 & monthint_et == 8
replace intyear = 2005 & monthint == 5 if intyear_et == 1997 & monthint_et == 9
replace intyear = 2005 & monthint == 6 if intyear_et == 1997 & monthint_et == 10
replace intyear = 2005 & monthint == 7 if intyear_et == 1997 & monthint_et == 11
replace intyear = 2005 & monthint == 8 if intyear_et == 1997 & monthint_et == 12
replace intyear = 2005 & monthint == 8 if intyear_et == 1997 & monthint_et == 12
replace intyear = 2005 & monthint == 9 if intyear_et == 1997 & monthint_et == 1
replace intyear = 2005 & monthint == 10 if intyear_et == 1997 & monthint_et == 2
replace intyear = 2005 & monthint == 12 if intyear_et == 1997 & monthint_et == 3

replace intyear = 2011 & monthint == 12 if intyear_et == 2003 & monthint_et == 5
replace intyear = 2010 & monthint == 1 if intyear_et == 2003 & monthint_et == 4
replace intyear = 2010 & monthint == 2 if intyear_et == 2003 & monthint_et == 6
replace intyear = 2010 & monthint == 4 if intyear_et == 2003 & monthint_et == 8
replace intyear = 2011 & monthint == 5 if intyear_et == 2003 & monthint_et == 9
replace intyear = 2011 & monthint == 6 if intyear_et == 2003 & monthint_et == 10
replace intyear = 2011 & monthint == 7 if intyear_et == 2003 & monthint_et == 11
replace intyear = 2011 & monthint == 8 if intyear_et == 2003 & monthint_et == 12
replace intyear = 2011 & monthint == 8 if intyear_et == 2003 & monthint_et == 12
replace intyear = 2011 & monthint == 9 if intyear_et == 2003 & monthint_et == 1
replace intyear = 2011 & monthint == 10 if intyear_et == 2003 & monthint_et == 2
replace intyear = 2011 & monthint == 12 if intyear_et == 2003 & monthint_et == 3

replace intyear = 2016 & monthint == 12 if intyear_et == 2008 & monthint_et == 5
replace intyear = 2015 & monthint == 1 if intyear_et == 2008 & monthint_et == 4
replace intyear = 2015 & monthint == 2 if intyear_et == 2008 & monthint_et == 6
replace intyear = 2015 & monthint == 4 if intyear_et == 2008 & monthint_et == 8
replace intyear = 2016 & monthint == 5 if intyear_et == 2008 & monthint_et == 9
replace intyear = 2016 & monthint == 6 if intyear_et == 2008 & monthint_et == 10
replace intyear = 2016 & monthint == 7 if intyear_et == 2008 & monthint_et == 11
replace intyear = 2016 & monthint == 8 if intyear_et == 2008 & monthint_et == 12
replace intyear = 2016 & monthint == 8 if intyear_et == 2008 & monthint_et == 12
replace intyear = 2016 & monthint == 9 if intyear_et == 2008 & monthint_et == 1
replace intyear = 2016 & monthint == 10 if intyear_et == 2008 & monthint_et == 2
replace intyear = 2016 & monthint == 12 if intyear_et == 2008 & monthint_et == 3

* save new dataset:
save "$raw/DHS_MenWomen", replace
