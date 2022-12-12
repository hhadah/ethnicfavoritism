********************************************************************************
******************** THIS IS A DO FILE FOR MERGING THE DATA ********************
******************** 				Hussain Hadah			********************
********************			Ethnic Favoritism Paper		********************
********************************************************************************
clear all
cls
********************************************************************************
********************************************************************************
/// Merge Polity Data with Heads of states
********************************************************************************
********************************************************************************
* Open Polity data
use "$raw/PolityIV.dta"
********************************************************************************
* merging command:
* Merges Polity IV
* with data on ethnicity
* of heads of states
merge 1:1 cowcode year using "$raw/AfricanLeadersStataData.dta"
********************************************************************************
* Replace some values that got lost in the merge
* Ethiopia 1994
replace democ = -88 if cowcode == 530 & year == 1994
replace autoc= -88 if cowcode == 530 & year == 1994
replace polity= -88 if cowcode == 530 & year == 1994
replace polity2= 1 if cowcode == 530 & year == 1994

* Ethiopia 1995
replace democ = 3 if cowcode == 530 & year == 1995
replace autoc= 2 if cowcode == 530 & year == 1995
replace polity= 1 if cowcode == 530 & year == 1995
replace polity2= 1 if cowcode == 530 & year == 1995

* Ethiopia 1996
replace democ = 3 if cowcode == 530 & year == 1996
replace autoc= 2 if cowcode == 530 & year == 1996
replace polity= 1 if cowcode == 530 & year == 1996
replace polity2= 1 if cowcode == 530 & year == 1996

* Ethiopia 1997
replace democ = 3 if cowcode == 530 & year == 1997
replace autoc= 2 if cowcode == 530 & year == 1997
replace polity= 1 if cowcode == 530 & year == 1997
replace polity2= 1 if cowcode == 530 & year == 1997

* Ethiopia 1998
replace democ = 3 if cowcode == 530 & year == 1998
replace autoc= 2 if cowcode == 530 & year == 1998
replace polity= 1 if cowcode == 530 & year == 1998
replace polity2= 1 if cowcode == 530 & year == 1998

* Ethiopia 1999
replace democ = 3 if cowcode == 530 & year == 1999
replace autoc= 2 if cowcode == 530 & year == 1999
replace polity= 1 if cowcode == 530 & year == 1999
replace polity2= 1 if cowcode == 530 & year == 1999

* Ethiopia 2000
replace democ = 3 if cowcode == 530 & year ==  2000
replace autoc= 2 if cowcode == 530 & year ==   2000
replace polity= 1 if cowcode == 530 & year ==  2000
replace polity2= 1 if cowcode == 530 & year == 2000

* Ethiopia 2001
replace democ = 3 if cowcode == 530 & year ==  2001
replace autoc= 2 if cowcode == 530 & year ==   2001
replace polity= 1 if cowcode == 530 & year ==  2001
replace polity2= 1 if cowcode == 530 & year == 2001

* Ethiopia 2002
replace democ = 3 if cowcode == 530 & year ==  2002
replace autoc= 2 if cowcode == 530 & year ==   2002
replace polity= 1 if cowcode == 530 & year ==  2002
replace polity2= 1 if cowcode == 530 & year == 2002

* Ethiopia 2003
replace democ = 3 if cowcode == 530 & year ==  2003
replace autoc= 2 if cowcode == 530 & year ==   2003
replace polity= 1 if cowcode == 530 & year ==  2003
replace polity2= 1 if cowcode == 530 & year == 2003
********************************************************************************
* drop variables and observations that did not merge
drop scode country
drop if cowcode == 452 & _merge == 2
drop if cowcode == 552 & _merge == 2
drop if cowcode == . & _merge == 2
********************************************************************************
* drop values from Polity that are out of sample
drop if _merge == 1
drop _merge
********************************************************************************
* country name in DHS is an integer
* recode. Therefore, I will have to
* convert country names in this file 
* into that recode
gen country = .
replace country = 24 if ctryname == "Angola"
replace country = 204 if ctryname == "Benin"
replace country = 854 if ctryname == "Burkina Faso"
replace country = 108 if ctryname == "Burundi"
replace country = 120 if ctryname == "Cameroon"
replace country = 384 if ctryname == "Cote d'Ivoire"
replace country = 180 if ctryname == "Democratic Republic of the Congo (Zaire, Congo-Kinshasha)"
replace ctryname = "Democratic Republic of the Congo" if ctryname == "Democratic Republic of the Congo (Zaire, Congo-Kinshasha)"
replace country = 231 if ctryname == "Ethiopia"
replace country = 288 if ctryname == "Ghana"
replace country = 324 if ctryname == "Guinea"
replace country = 404 if ctryname == "Kenya"
replace country = 454 if ctryname == "Malawi"
replace country = 466 if ctryname == "Mali"
replace country = 508 if ctryname == "Mozambique"
replace country = 516 if ctryname == "Namibia"
replace country = 562 if ctryname == "Niger"
replace country = 566 if ctryname == "Nigeria"
replace country = 686 if ctryname == "Senegal"
replace country = 710 if ctryname == "South Africa"
replace country = 800 if ctryname == "Uganda"
replace country = 894 if ctryname == "Zambia"
replace country = 716 if ctryname == "Zimbabwe"
********************************************************************************
* save the data successfully merge 
// drop Notes N O
save "$raw/PolityHeadsofStates.dta", replace

********************************************************************************
/*
Merging Heads of States and Polity
data with the DHS data recode of 
men and women  for primary school
completion dataset
*/
********************************************************************************
clear all
cls
********************************************************************************
********************************************************************************
* coethnicity from 7 years old
********************************************************************************
********************************************************************************
* open DHS
use "$raw/DHS_MenWomen.dta"
********************************************************************************
* generate a variable that 
* equals the year the observation
* was six year old
rename year smaple_year 
gen YearOld_7 = intyear - age + 7
rename YearOld_7 year
label var year "The year the observations turned 7."
********************************************************************************
*merge DHS to the leader ethnicity and polity iv dataset:
merge m:1 country year using "$raw/PolityHeadsofStates.dta"
drop if _merge == 1
drop if _merge == 2
drop _merge
* generate coethnic dummy:
gen coethnic = 0
label variable coethnic "=1 if individual and leader from the same ethnic group"
foreach v of varlist homelangao ethnicitybj ethnicitybf nationalitybf nationalitybi ethnicitycm ethnicitycd ethnicityci98 ethnicityet ethnicitygh ethnicitygn ethnicityke ethnicitymw ethnicityml ethnicitymz ethnicitynm ethnicityne ethnicityng ethnicityng2 ethnicitysn ethnicityza ethnicityug ethnicityzm ethnicityzw {
replace coethnic = 1 if DHS_Ethnic_Recode == `v'
}
********************************************************************************
* rename variables for future merge:
rename year YearOld_7
rename cowcode cowcode_7
rename democ democ_7
rename autoc autoc_7
rename polity polity_7
rename polity2 polity2_7
rename nhead nhead_7
rename npost npost_7
rename democracy democracy_7
rename tt tt_7
rename ttd ttd_7
rename Ethnicity Ethnicity_7
rename coethnic coethnic_7
rename DHS_Ethnic_Recode DHS_Ethnic_Recode_7

save "$raw/DHS_FR_matched7yo.dta", replace
********************************************************************************
********************************************************************************
* coethnicity from 8-13 years old
********************************************************************************
********************************************************************************
forvalues i = 8/13{
********************************************************************************
* open DHS
local k = `i'-1
use "$raw/DHS_FR_matched`k'yo.dta"

********************************************************************************
* generate a variable that 
* equals the year the observation
* was six year old
gen YearOld_`i' = intyear - age + `i'
rename YearOld_`i' year
label var year "The year the observations turned `i'."
********************************************************************************
*merge DHS to the leader ethnicity and polity iv dataset:
merge m:1 country year using "$raw/PolityHeadsofStates.dta"
drop if _merge == 1
drop if _merge == 2
drop _merge
* generate coethnic dummy:
gen coethnic = 0
label variable coethnic "=1 if individual and leader from the same ethnic group"
foreach v of varlist homelangao ethnicitybj ethnicitybf nationalitybf nationalitybi ethnicitycm ethnicitycd ethnicityci98 ethnicityet ethnicitygh ethnicitygn ethnicityke ethnicitymw ethnicityml ethnicitymz ethnicitynm ethnicityne ethnicityng ethnicityng2 ethnicitysn ethnicityza ethnicityug ethnicityzm ethnicityzw {
replace coethnic = 1 if DHS_Ethnic_Recode == `v'
}
********************************************************************************
* rename variables for future merge:
rename year YearOld_`i'
rename cowcode cowcode_`i'
rename democ democ_`i'
rename autoc autoc_`i'
rename polity polity_`i'
rename polity2 polity2_`i'
rename nhead nhead_`i'
rename npost npost_`i'
rename democracy democracy_`i'
rename tt tt_`i'
rename ttd ttd_`i'
rename Ethnicity Ethnicity_`i'
rename coethnic coethnic_`i'
rename DHS_Ethnic_Recode DHS_Ethnic_Recode_`i'

save "$raw/DHS_FR_matched`i'yo.dta", replace
clear
cls
}
// * gen a variable
// * to identify this dataset
use "$raw/DHS_FR_matched13yo.dta"
save "$raw/DHS_PrimSchl.dta", replace
// clear
// cls


********************************************************************************
/*
Merging Heads of States and Polity
data with the DHS data recode of 
men and women  for Infacnt Mortality
*/
********************************************************************************
clear all
cls
********************************************************************************
********************************************************************************
********************    Merge DHS with leaders and polity   ********************
********************************************************************************
clear all
cls
* open DHS
use "$raw/ChildRecode.dta"

* convert Ethipian calendar
* to gregorian calendar
gen y_gregorian=.
replace y_gregorian=kidbirthyr_et+7 if kidbirthmo_et>9
replace y_gregorian=kidbirthyr_et+8 if kidbirthmo_et<9
replace kidbirthyr = y_gregorian if y_gregorian !=.
drop if missing(kidbirthyr)

* generatte a coethnicity variable
* that is equal to one
* if the leader's ethnicity 
* matches the mother's
* at the time of birth
* then merge with polity
rename year sample_year
rename kidbirthyr year

*merge DHS to the leader ethnicity and polity iv dataset:
merge m:1 country year using "$raw/PolityHeadsofStates.dta"
drop if _merge == 1
drop if _merge == 2
drop _merge

save "$raw/DHS_Infantdata_countries_matched", replace 

* generate leader ethnicity dummy
* that is similiar to the one in DHS
* encode Ethnicity, generate(Leader_ethnic)

* drop observations from Brundi because
* DHS does not have ethnic info
drop if country == 108

* generate coethnic dummy:
gen coethnic = 0
label variable coethnic "=1 if individual and leader from the same ethnic group"

foreach v of varlist ethnicitybj ethnicitybf ethnicitycm ethnicitycd ethnicityci98 ethnicityet ethnicitygh ethnicitygn ethnicityke ethnicitymw ethnicityml ethnicitymz ethnicityne ethnicityng ethnicityng2 ethnicitysn ethnicityza ethnicityug ethnicityzm ethnicityzw {
replace coethnic = 1 if DHS_Ethnic_Recode == `v'
}
gen DataSet = 2
label define DataSet 1 "Primary School" 2 "Infant Mortality" 3 "Electrification and Water" 4 "Wealth"

* save DHS data with coethnicity
save "$raw/DHS_Infantdata_polity_coethnic.dta", replace

clear
cls

********************************************************************************
/*
Merging Heads of States and Polity
data with the DHS data recode of 
men and women  for Electrificaiton and Water
*/
********************************************************************************
********************************************************************************
********************************************************************************
********************    Merge DHS with leaders and polity   ********************
********************************************************************************
clear all
cls

* open DHS
use "$raw/DHS_MenWomen.dta"


* generatte a coethnicity variable
* that is equal to one
* if the leader's ethnicity 
* matches the mother's
* at the time of birth
* then merge with polity
rename year smaple_year 
gen TwoYearPrior = intyear - 1
rename TwoYearPrior year
label var year "A variable that is equal to interview year - 2."

*merge DHS to the leader ethnicity and polity iv dataset:
merge m:1 country year using "$raw/PolityHeadsofStates.dta"
drop if _merge == 1
drop if _merge == 2
drop _merge

save "$raw/ElectrificationWaterMatched.dta", replace 

* generate leader ethnicity dummy
* that is similiar to the one in DHS
* encode Ethnicity, generate(Leader_ethnic)

* drop observations from Brundi because
* DHS does not have ethnic info
drop if country == 108

* generate coethnic dummy:
gen coethnic = 0
label variable coethnic "=1 if individual and leader from the same ethnic group"

foreach v of varlist ethnicitybj ethnicitybf ethnicitycm ethnicitycd ethnicityci98 ethnicityet ethnicitygh ethnicitygn ethnicityke ethnicitymw ethnicityml ethnicitymz ethnicityne ethnicityng ethnicityng2 ethnicitysn ethnicityza ethnicityug ethnicityzm ethnicityzw {
replace coethnic = 1 if DHS_Ethnic_Recode == `v'
}
gen DataSet = 3
label define DataSet 1 "Primary School" 2 "Infant Mortality" 3 "Electrification and Water" 4 "Wealth"

* save DHS data with coethnicity
save "$raw/DHS_ElectrificationWater.dta", replace

clear
cls

********************************************************************************
/*
Merging Heads of States and Polity
data with the DHS data recode of 
men and women  for Wealth
*/

********************************************************************************
clear all
cls
********************************************************************************
********************************************************************************
* coethnicity 4 years before interview
********************************************************************************
********************************************************************************
* open DHS
use "$raw/DHS_MenWomen.dta"
********************************************************************************
* generate a variable that 
* equals the year the observation
* was six year old
rename year smaple_year 
gen YearPrior_4 = intyear - 4
rename YearPrior_4 year
label var year "A variable that equals interview year - 4."
********************************************************************************
*merge DHS to the leader ethnicity and polity iv dataset:
merge m:1 country year using "$raw/PolityHeadsofStates.dta"
drop if _merge == 1
drop if _merge == 2
drop _merge
* generate coethnic dummy:
gen coethnic = 0
label variable coethnic "=1 if individual and leader from the same ethnic group"
foreach v of varlist homelangao ethnicitybj ethnicitybf nationalitybf nationalitybi ethnicitycm ethnicitycd ethnicityci98 ethnicityet ethnicitygh ethnicitygn ethnicityke ethnicitymw ethnicityml ethnicitymz ethnicitynm ethnicityne ethnicityng ethnicityng2 ethnicitysn ethnicityza ethnicityug ethnicityzm ethnicityzw {
replace coethnic = 1 if DHS_Ethnic_Recode == `v'
}
********************************************************************************
* rename variables for future merge:
rename year YearPrior_4
rename cowcode cowcode_4
rename democ democ_4
rename autoc autoc_4
rename polity polity_4
rename polity2 polity2_4
rename nhead nhead_4
rename npost npost_4
rename democracy democracy_4
rename tt tt_4
rename ttd ttd_4
rename Ethnicity Ethnicity_4
rename coethnic coethnic_4
rename DHS_Ethnic_Recode DHS_Ethnic_Recode_4

save "$raw/DHS_Wealtth_matched4.dta", replace
********************************************************************************
********************************************************************************
* coethnicity from 3-0 years old
********************************************************************************
********************************************************************************
forvalues i = 3(-1)0{
********************************************************************************
* open DHS
local k = `i' + 1
use "$raw/DHS_Wealtth_matched`k'.dta"

********************************************************************************
* generate a variable that 
* equals the year the observation
* was six year old
gen YearPrior_`i' = intyear - `i'
rename YearPrior_`i' year
label var year "The year the observations turned `i'."
********************************************************************************
*merge DHS to the leader ethnicity and polity iv dataset:
merge m:1 country year using "$raw/PolityHeadsofStates.dta"
drop if _merge == 1
drop if _merge == 2
drop _merge
* generate coethnic dummy:
gen coethnic = 0
label variable coethnic "=1 if individual and leader from the same ethnic group"
foreach v of varlist homelangao ethnicitybj ethnicitybf nationalitybf nationalitybi ethnicitycm ethnicitycd ethnicityci98 ethnicityet ethnicitygh ethnicitygn ethnicityke ethnicitymw ethnicityml ethnicitymz ethnicitynm ethnicityne ethnicityng ethnicityng2 ethnicitysn ethnicityza ethnicityug ethnicityzm ethnicityzw {
replace coethnic = 1 if DHS_Ethnic_Recode == `v'
}
********************************************************************************
* rename variables for future merge:
rename year YearPrior_`i'
rename cowcode cowcode_`i'
rename democ democ_`i'
rename autoc autoc_`i'
rename polity polity_`i'
rename polity2 polity2_`i'
rename nhead nhead_`i'
rename npost npost_`i'
rename democracy democracy_`i'
rename tt tt_`i'
rename ttd ttd_`i'
rename Ethnicity Ethnicity_`i'
rename coethnic coethnic_`i'
rename DHS_Ethnic_Recode DHS_Ethnic_Recode_`i'

save "$raw/DHS_Wealtth_matched`i'.dta", replace
clear
cls
}
* gen a variable
* to identify this dataset
use "$raw/DHS_Wealtth_matched0.dta"
gen DataSet = 4
label var DataSet "Variable to identify the different datasets"
save "$raw/DHS_Wealth.dta", replace
clear
cls
