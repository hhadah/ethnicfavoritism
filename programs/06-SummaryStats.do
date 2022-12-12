/*
summary statistics for men and women recode
*/

clear
cls

global DataDHS "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/RawData/DHS_append"
use "$DataDHS/DHS_MenWomen.dta"

gen Urban = .
replace Urban = 0 if urban == 2
replace Urban = 1 if urban == 1

gen electricity = .
replace electricity = 1 if electrc == 1
replace electricity = 0 if electrc == 0

gen Literacy = .
replace Literacy = 0 if lit2 == 0
replace Literacy = 1 if lit2 == 10
replace Literacy = 1 if lit2 == 11
replace Literacy = 1 if lit2 == 12

gen Poorest = .
replace Poorest = 0 if wealthq != 1
replace Poorest = 1 if wealthq == 1

gen Poorer = .
replace Poorer = 0 if wealthq != 2
replace Poorer = 1 if wealthq == 2

gen Middle = .
replace Middle = 0 if wealthq != 3
replace Middle = 1 if wealthq == 3

gen Richer = .
replace Richer = 0 if wealthq != 4
replace Richer = 1 if wealthq == 4

gen Richest = .
replace Richest = 0 if wealthq != 5
replace Richest = 1 if wealthq == 5

gen CompletedPrimaryEdu = 0
label var CompletedPrimaryEdu "=1 if completed primary school, 0 o/w"
replace CompletedPrimaryEdu = 1 if educlvl==1
replace CompletedPrimaryEdu = 1 if educlvl==2
replace CompletedPrimaryEdu = 1 if educlvl==3

sum CompletedPrimaryEdu

sum age Urban cheb hhmemtotal electricity Literacy female Poorest Poorer Middle Richer Richest

sum edyrtotal if edyrtotal < 96
/*
summary statistics for children
*/

clear
cls

global ChildRecode "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/RawData/ChildRecode"
use "$ChildRecode/ChildRecode.dta"

gen infant_mortality = 0
label var infant_mortality "Infant mortality"

replace infant_mortality = 1 if kidalive == 0 & kidagedeath <= 212
********************************************************************************
* Construct infant survival variable
********************************************************************************
gen infant_survival = 0
label var infant_survival "Infant survival"
replace infant_survival = 1 - infant_mortality

sum infant_survival
sum kidcurage if kidcurage < 97

gen KidFemale = .
replace KidFemale = 1 if kidsex == 2
replace KidFemale = 0 if kidsex == 1

sum KidFemale 

sum edyrtotal if edyrtotal < 96
