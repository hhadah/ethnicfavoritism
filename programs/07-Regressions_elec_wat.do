/*
This do file produces the different
regressions from my analysis
*/
********************************************************************************
* Second, Electrificattion and Access to Water
clear
cls
set matsize 11000
global RegressionResults "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/Regressions_and_Results"
global ElecWaterData "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/MergedData/ElectrificationWater"
* set working directory
cd "$RegressionResults"

* open data set
use "$ElecWaterData/DHS_ElectrificationWater.dta"
********************************************************************************
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
quietly tabulate ethnicitynm, 	generate(NamibiaEth)
quietly tabulate ethnicityne, 	generate(NigerEth)
quietly tabulate ethnicityng, 	generate(NigeriaEth)
quietly tabulate ethnicitysn, 	generate(SenegalEth)
quietly tabulate ethnicityza, 	generate(SouthAfricaEth)
quietly tabulate ethnicityug, 	generate(UgandaEth)
quietly tabulate ethnicityzm, 	generate(ZambiaEth)
quietly tabulate ethnicityzw, 	generate(ZimbabweEth)
* replace missing values with 0
foreach v of varlist BeninEth1-ZimbabweEth6 {
replace `v' = 0 if missing(`v')
}
* label variable
label var female "Female"
rename urban urban1
gen urban = 0
replace urban  = 1 if urban1 == 1
drop urban1
label var urban "Urban"
* generate electrification and access to water variables
* gen Access to water Ordinal variable
gen AccessToWater = 1
// label define WaterSource 1 "Water source is natural." 2 "unprotected borehole or well." 3 "protected borehole or well." 4 "Water soruce is piped."
label var AccessToWater "Water"
replace AccessToWater = 4 if drinkwtr>=1000 & drinkwtr< 2000 | drinkwtr == 5400	
replace AccessToWater = 4 if drinkwtr == 5400	

replace AccessToWater = 1 if drinkwtr>=3000 & drinkwtr< 5400	
replace AccessToWater = 2 if drinkwtr>=2100 & drinkwtr< 2200
replace AccessToWater = 2 if drinkwtr>=2300 & drinkwtr< 3000
replace AccessToWater = 3 if drinkwtr>=2200 & drinkwtr< 2300
* gen Electrification Dummy
gen Electrification = 0
replace Electrification = 1 if electrc == 1
label var Electrification "Electrification"
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
gen Democracy_dem_dic = democracy
label var Democracy_dem_dic "Democracy"
gen inter_dem_dic = Democracy_dem_dic*coethnic
********************************************************************************
********************************************************************************
* regressions on Electricity and access to water
********************************************************************************
gen birth_year = intyear - age
label var coethnic "Coethnic"
rename polity2 Polity
* set up local variables
// local DemInterCoethVars inter_Democracy_coethnic inter_OpenAnocracy_coethnic inter_ClosedAnocracy_coethnic
// local PolityGroups Democracy OpenAnocracy ClosedAnocracy
local EthnicFEs "BeninEth1-ZimbabweEth6"
// local RegionFEs "geo_bj1996_2011 geo_bf2003_2010 geo_bi2010_2016 geo_cm1991_2011 geo_cd2007_2013 geo_et2000_2016 geo_gh1988_2014 geo_gn1999_2012 geo_ke1989_2014 geo_mw1992_2016 geo_ml1987_2012 geo_mz1997_2011 geo_nm1992_2013 geo_ne1992_2012 geo_ng2003_2013 geo_sn1986_2017 geo_za1998_2016 geo_ug1995_2016 geo_zm1992_2013 geo_zw1994_2015"
egen EthClusters = group(BeninEth1-ZimbabweEth6)
********************************************************************************
reghdfe 	Electrification coethnic urban female 								, absorb(i.birth_year  i.age) cluster(EthClusters) noomit
reghdfe		Electrification coethnic urban female 			if Democracy == 1	, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
reghdfe 	Electrification coethnic urban female 			if Anocracy == 1	, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit  
reghdfe 	Electrification coethnic urban female 			if Autocracy == 1	, absorb(i.birth_year  i.age) cluster(EthClusters) noomit  
reghdfe 	AccessToWater coethnic urban female 								, absorb(i.birth_year  i.age) cluster(EthClusters) noomit
reghdfe		AccessToWater coethnic urban female 			if Democracy == 1	, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
reghdfe 	AccessToWater coethnic urban female 			if Anocracy == 1	, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit  
reghdfe 	AccessToWater coethnic urban female 			if Autocracy == 1	, absorb(i.birth_year  i.age) cluster(EthClusters) noomit 
local electricity_water Electrification AccessToWater
foreach var in `electricity_water'{
// * Ethnic favoritism in education 
// * with Country-Year fixed effects,
// * Age FE and 5 years groups FE
// eststo did_ct`var': xi: reg `var' coethnic urban female i.cowcode*i.birth_year  i.age i.age5year , cluster(birth_year) noomit  
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
eststo did_eth`var': 				reghdfe 	`var' coethnic urban female 								, absorb(i.birth_year  i.age) cluster(EthClusters) noomit
eststo dem`var': 		reghdfe		`var' coethnic urban female 			if Democracy == 1	, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
eststo anoc`var': 		reghdfe 	`var' coethnic urban female 			if Anocracy == 1	, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit  
eststo autoc`var': 		reghdfe 	`var' coethnic urban female 			if Autocracy == 1	, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit  
#delimit;
coefplot 	(dem`var', label(Democracy))
			(anoc`var', label(Anocracy)) 
			(autoc`var', label(Autocracy)),
			aseq swapnames legend(off)
			title("The Co-ethnic Effect on `var'" "with Ethnic Groups and Time Fixed Effects by Democratic Group") 
			keep(coethnic) xline(0, lcolor(red))
			msymbol(O) msize(large) levels(90)
			coeflabels(dem`var' = "Democracy"
					   anoc`var' = "Anocracy"
					   autoc`var' = "Autocracy");
graph export coeth_byGroups3.png, replace;
 #delimit cr
********************************************************************************
********************************************************************************
* Ethnic favoritism in education 
* with ragion and birth 
* year fixed effects and
* ethnicity FE
// foreach v of varlist geo_bj1996_2011 geo_bf2003_2010 geo_bi2010_2016 geo_cm1991_2011 geo_cd2007_2013 geo_et2000_2016 geo_gh1988_2014 geo_gn1999_2012 geo_ke1989_2014 geo_mw1992_2016 geo_ml1987_2012 geo_mz1997_2011 geo_nm1992_2013 geo_ne1992_2012 geo_ng2003_2013 geo_sn1986_2017 geo_za1998_2016 geo_ug1995_2016 geo_zm1992_2013 geo_zw1994_2015 {
// replace `v' = 0 if missing(`v')
// }
//
// eststo did_reg`var':xi: reg `var' coethnic urban female i.`RegionFEs' i.birth_year  i.age i.age5year , cluster(birth_year)
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
// eststo did_demct`var': xi: reg `var' $DemInterCoethVars $PolityGroups urban female coethnic i.cowcode*i.birth_year i.age i.age5year  , cluster(birth_year) noomit  
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
eststo did_demeth`var': reghdfe `var' $DemInterCoethVars $PolityGroups urban female coethnic, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
********************************************************************************
* Coethnicity and Democracy
* with Regional FE
********************************************************************************
// eststo did_demreg`var':  xi: reg `var' $DemInterCoethVars $PolityGroups urban female coethnic i.`RegionFEs' i.birth_year  i.age i.age5year , cluster(birth_year)
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
eststo did_contdem`var': reghdfe `var' inter_polity2_coethnic coethnic urban female Polity, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
********************************************************************************
* Democracy-Diictatorship index regression
********************************************************************************
* average democracy-diictatorship index
eststo demdic`var': reghdfe `var' inter_dem_dic coethnic Democracy_dem_dic urban female, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
}
