/*
This do file produces the different
regressions from my analysis
*/
********************************************************************************
* Fourth, InfantMortality
clear
cls
set matsize 11000
global RegressionResults "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/Regressions_and_Results"
global MortData "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/MergedData/ChildrenRecode"
* set working directory
cd "$RegressionResults"
* open data set
use "$MortData/DHS_Infantdata_polity_coethnic.dta"
********************************************************************************
* Possible controls
* bidx age hhkidlt5 kidsex year year kidbord
********************************************************************************
* gen dummy variables for ethnicities by countries:
quietly tabulate homelangao, 	generate(AngolaEth)
quietly tabulate ethnicitybj, 	generate(BeninEth)
quietly tabulate ethnicitybf, 	generate(BurkinaFasoEth)
quietly tabulate ethnicitycm, 	generate(CameronEth)
quietly tabulate ethnicityci98, generate(IvoryCoastEth)
quietly tabulate ethnicitycd, 	generate(CongoEth)
quietly tabulate ethnicityet, 	generate(EthiopiaEth)
quietly tabulate ethnicitygh, 	generate(GhanaEth)
quietly tabulate ethnicitygn, 	generate(GuineaEth)
quietly tabulate ethnicityke, 	generate(KenyaEth)
quietly tabulate ethnicitymw, 	generate(MalawiEth)
quietly tabulate ethnicityml, 	generate(MaliEth)
quietly tabulate ethnicitymz, 	generate(MozambiqueEth)
quietly tabulate ethnicityne, 	generate(NigerEth)
quietly tabulate ethnicityng, 	generate(NigeriaEth)
quietly tabulate ethnicitysn, 	generate(SenegalEth)
quietly tabulate ethnicityza, 	generate(SouthAfricaEth)
quietly tabulate ethnicityug, 	generate(UgandaEth)
quietly tabulate ethnicityzm, 	generate(ZambiaEth)
quietly tabulate ethnicityzw, 	generate(ZimbabweEth)
foreach v of varlist homelangao-ethnicityzw {
replace `v' = 0 if missing(`v')
}
local ethnicities ethnicitybj-ethnicityzw

* replace missing values with 0
foreach v of varlist AngolaEth1-ZimbabweEth6 {
replace `v' = 0 if missing(`v')
replace `v' = 0 if `v' == .

}
* label variable
rename urban urban1
gen urban = 0
replace urban  = 1 if urban1 == 1
drop urban1
label var urban "Urban"
********************************************************************************
* democratic groups
gen Democracy = 0
replace Democracy = 1 if polity2<=9 & polity2>=6

gen Anocracy = 0
replace Anocracy = 1 if polity2>=-5 & polity2<=5
// gen OpenAnocracy = 0
// replace OpenAnocracy = 1 if polity2>=1 & polity2<=5
//
// gen ClosedAnocracy = 0
// replace ClosedAnocracy = 1 if polity2<=0 & polity2>=-5

gen Autocracy = 0
replace Autocracy = 1 if Democracy == 0 & Anocracy == 0

// gen Failed_or_Occupied = 0
// replace Failed_or_Occupied = 1 if polity2 == .
********************************************************************************
* generate interaction terms between the groups and coethnicity
gen inter_Democracy_coethnic = Democracy*coethnic
gen inter_Anocracy_coethnic = Anocracy*coethnic
// gen inter_OpenAnocracy_coethnic = OpenAnocracy*coethnic
// gen inter_ClosedAnocracy_coethnic = ClosedAnocracy*coethnic
gen inter_Autocracy_coethnic = Autocracy*coethnic
// gen inter_FailedOccupied_coethnic = Failed_or_Occupied*coethnic
gen inter_polity2_coethnic = polity2*coethnic
label var inter_Democracy_coethnic "$ I_{ 10 \geq Polity IV \geq 6} \times Coethnic Leader $"
label var inter_Anocracy_coethnic "$ I_{ 5 \geq Polity IV \geq -5} \times Coethnic Leader $"
// label var inter_OpenAnocracy_coethnic "$ I_{ 5 \geq Polity IV \geq 1} \times Coethnic Leader $"
// label var inter_ClosedAnocracy_coethnic "$ I_{ 0 \geq Polity IV \geq -5} \times Coethnic Leader $"
label var inter_Autocracy_coethnic "$ I_{ -5 \geq Polity IV \geq 10} \times Coethnic Leader $"
// label var inter_FailedOccupied_coethnic "\textit{Failed state}$\times$\textit{Coethnic Leader}"
label var inter_polity2_coethnic "\textit{Polity}$\times$\textit{Coethnic Leader}"
********************************************************************************
* Construct infant mortality variable
********************************************************************************
gen infant_mortality = 0
label var infant_mortality "Infant mortality"
// drop if kidagedeath == 198
// drop if kidagedeath == 199
// drop if kidagedeath == 297
// drop if kidagedeath == 298
// drop if kidagedeath == 299
// drop if kidagedeath >= 397

replace infant_mortality = 1 if kidalive == 0 & kidagedeath <= 212
********************************************************************************
* Construct infant survival variable
********************************************************************************
gen infant_survival = 0
label var infant_survival "Infant survival"
replace infant_survival = 1 - infant_mortality
********************************************************************************
********************************************************************************
********************************************************************************
* regressions on Infant Mortaltiy
********************************************************************************
gen birth_year = intyear - age
label var coethnic "Coethnic"
rename polity2 Polity
* set up local variables
local EthnicFEs "AngolaEth1-ZimbabweEth6"
// sum BeninEth1-ZimbabweEth6
// tab `EthnicFEs', sum(coethnic)
// sort `EthnicFEs'
// by `EthnicFEs': egen frac_coethnic = mean(coethnic)
// tab frac_coethnic
// local RegionFEs "geo_bj1996_2011 geo_bf2003_2010 geo_cm1991_2011 geo_cd2007_2013 geo_et2000_2016 geo_gh1988_2014 geo_gn1999_2012 geo_ke1989_2014 geo_mw1992_2016 geo_ml1987_2012 geo_mz1997_2011 geo_ne1992_2012 geo_ng2003_2013 geo_sn1986_2017 geo_za1998_2016 geo_ug1995_2016 geo_zm1992_2013"
********************************************************************************
* Ethnic favoritism in education 
* with Country-Year fixed effects,
* Age FE and 5 years groups FE
// eststo did_ct_Inf: xi: reg infant_mortality coethnic urban kidbord age kidsex i.cowcode*i.year   i.age i.age5year, cluster(year) noomit  
// quietly estadd local fixedcountry "Yes", replace
// quietly estadd local fixedyear "Yes", replace
// quietly estadd local fixedcountry_year "Yes", replace
// quietly estadd local regionFE "No", replace
// quietly estadd local EthnicFE "No", replace
// quietly estadd local clusterSE "Yes", replace
// quietly estadd local Controls "Yes", replace

********************************************************************************
* Ethnic favoritism in education 
* with country and birth 
* year fixed effects and
* ethnicity FE
egen EthClusters = group(AngolaEth1-ZimbabweEth6)
local EthnicFEs "AngolaEth1-ZimbabweEth6"
// xi: reg infant_mortality coethnic `EthnicFEs', noomit 
// local ethnicities ethnicitybj-ethnicityzw
// xi: reg infant_mortality coethnic `ethnicities', noomit 

eststo did_eth_Inf: reghdfe infant_survival coethnic kidbord age urban kidsex, absorb(i.birth_year i.age) cluster(EthClusters) noomit
eststo did_eth_Inf_dem: reghdfe infant_survival coethnic kidbord age urban kidsex if Democracy == 1, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
eststo did_eth_Inf_anoc: reghdfe infant_survival coethnic kidbord age urban kidsex if Anocracy == 1, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit  
eststo did_eth_Inf_autoc: reghdfe infant_survival coethnic kidbord age urban kidsex if Autocracy == 1, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit 
#delimit;
coefplot 	(did_eth_Inf_dem, label(Democracy))
			(did_eth_Inf_anoc, label(Anocracy)) 
			(did_eth_Inf_autoc, label(Autocracy)),
			aseq swapnames legend(off)
			title("The Co-ethnic Effect on Infant Survival" "with Ethnic Groups and Time Fixed Effects by Democratic Group") 
			keep(coethnic) xline(0, lcolor(red))
			msymbol(O) msize(large) levels(90)
			coeflabels(did_eth_Inf_dem = "Democracy"
					   did_eth_Inf_anoc = "Anocracy"
					   did_eth_Inf_autoc = "Autocracy");
graph export coeth_byGroups2.png, replace;
 #delimit cr
********************************************************************************
********************************************************************************
* Ethnic favoritism in education 
* with ragion and birth 
* year fixed effects and
* ethnicity FE
// foreach v of varlist geo_bj1996_2011 geo_bf2003_2010 geo_cm1991_2011 geo_cd2007_2013 geo_et2000_2016 geo_gh1988_2014 geo_gn1999_2012 geo_ke1989_2014 geo_mw1992_2016 geo_ml1987_2012 geo_mz1997_2011 geo_ne1992_2012 geo_ng2003_2013 geo_sn1986_2017 geo_za1998_2016 geo_ug1995_2016 geo_zm1992_2013 {
// replace `v' = 0 if missing(`v')
// }
//
// eststo did_reg_Inf: xi: reg infant_mortality coethnic urban kidbord age kidsex i.`RegionFEs' i.year i.age i.age5year  , cluster(year)
// quietly estadd local fixedcountry "No", replace
// quietly estadd local fixedyear "Yes", replace
// quietly estadd local fixedcountry_year "No", replace
// quietly estadd local regionFE "Yes", replace
// quietly estadd local EthnicFE "No", replace
// quietly estadd local clusterSE "Yes", replace
// quietly estadd local Controls "Yes", replace
********************************************************************************
* regressions on interaction between democracy and Completed Primary Education
********************************************************************************
* Coethnicity and Democracy
* with time-country FE
********************************************************************************
// eststo did_demct_Inf: xi: reg infant_mortality $DemInterCoethVars $PolityGroups urban kidbord age kidsex  coethnic i.cowcode*i.year  i.age i.age5year , cluster(year) noomit  
// quietly estadd local fixedcountry "Yes", replace
// quietly estadd local fixedyear "Yes", replace
// quietly estadd local fixedcountry_year "Yes", replace
// quietly estadd local regionFE "No", replace
// quietly estadd local EthnicFE "No", replace
// quietly estadd local clusterSE "Yes", replace
// quietly estadd local Controls "Yes", replace
********************************************************************************
* Coethnicity and Democracy
* with ethnicity FE
********************************************************************************
eststo did_demeth_Inf: reghdfe infant_survival $DemInterCoethVars $PolityGroups kidbord age kidsex  coethnic, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit  
********************************************************************************
* Coethnicity and Democracy
* with Regional FE
********************************************************************************
// eststo did_demreg_Inf: xi: reg infant_mortality $DemInterCoethVars $PolityGroups urban kidbord age kidsex  coethnic i.`RegionFEs' i.year   i.age i.age5year, cluster(year)
// quietly estadd local fixedcountry "No", replace
// quietly estadd local fixedyear "Yes", replace
// quietly estadd local fixedcountry_year "No", replace
// quietly estadd local regionFE "Yes", replace
// quietly estadd local EthnicFE "No", replace
// quietly estadd local clusterSE "Yes", replace
// quietly estadd local Controls "Yes", replace
********************************************************************************
*contin polity score regression
********************************************************************************
eststo did_contdem_Inf: reghdfe infant_survival inter_polity2_coethnic coethnic urban kidbord age kidsex  Polity, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters)
********************************************************************************
* Democracy-Diictatorship index regression
********************************************************************************
* average democracy-diictatorship index
gen Democracy_dem_dic = democracy
label var Democracy_dem_dic "Democracy"
gen inter_dem_dic = Democracy_dem_dic*coethnic
eststo Democracy_Infdemdic: reghdfe infant_survival inter_dem_dic coethnic Democracy_dem_dic urban kidbord age kidsex, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters)
