********************************************************************************
******************** THIS IS A DO FILE is FOR APPENDING THE DATA ***************
******************** FROM DHS'S MEN AND WOMEN RECODES			 ***************
******************** 				Hussain Hadah			     ***************
********************			Ethnic Favoritism Paper		     ***************
********************************************************************************

********************************************************************************
* First, export the variable
* names from the two datasets
********************************************************************************
* Men:

* Open men's recode data:
use "$raw/MenRecode"
*order variables:
order _all, alphabetic
********************************************************************************
* Keep one observation:
sample 1, count
********************************************************************************
* Export variable 
* names and Labels
preserve
    describe, replace clear
    list
    export excel using "$raw/MenVars.xlsx", replace first(var)
restore
********************************************************************************
********************************************************************************
clear
cls
********************************************************************************
* Women:

* Open women's recode data:
use "$raw/WomenRecode.dta"
*order variables:
order _all, alphabetic
********************************************************************************
* Keep one observation:
sample 1, count
********************************************************************************
* Export variable 
* names and Labels
preserve
    describe, replace clear
    list
    export excel using "$raw/WomenVars.xlsx", replace first(var)
restore
********************************************************************************
clear
cls
********************************************************************************
* rename vars in MenRecode
* to match those in WomenRecod
********************************************************************************

********************************************************************************
* Open men's recode data:
use "$raw/MenRecode"
********************************************************************************
* rename commands:
rename agemn age
rename age5yearmn age5year
rename birthyearmn birthyear
rename clusternomn clusterno
rename edachievermn edachiever
rename educlvlmn educlvl
rename edyrtotalmn edyrtotal
rename electrchh electrc
rename ethnicitymn_bf ethnicitybf
rename ethnicitymn_bj ethnicitybj
rename ethnicitymn_cd ethnicitycd
rename ethnicitymn_ci ethnicityci98
rename ethnicitymn_cm ethnicitycm
rename ethnicitymn_et ethnicityet
rename ethnicitymn_gh ethnicitygh
rename ethnicitymn_gn ethnicitygn
rename ethnicitymn_ke ethnicityke
rename ethnicitymn_ml ethnicityml
rename ethnicitymn_mw ethnicitymw
rename ethnicitymn_mz ethnicitymz
rename ethnicitymn_ne ethnicityne
rename ethnicitymn_ng1 ethnicityng
rename ethnicitymn_ng2 ethnicityng2
rename ethnicitymn_nm ethnicitynm
rename ethnicitymn_sn ethnicitysn
rename ethnicitymn_ug ethnicityug
rename ethnicitymn_za ethnicityza
rename ethnicitymn_zm ethnicityzm
rename ethnicitymn_zw ethnicityzw
rename intyearmn intyear
rename lit2mn lit2
rename perweightmn perweight
rename religionmn religion
rename residentmn resident
rename stratamn strata
rename wealthqmn wealthq
rename wealthsmn wealths
rename intyearmn_et intyear_et
********************************************************************************
* save commands:
save "$raw/MenRecodeVarMatched", replace
