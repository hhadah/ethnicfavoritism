/*
This do file produces the different
regressions from my analysis
*/
********************************************************************************
* Third, Wealth
clear
cls
set matsize 11000
global RegressionResults "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/Regressions_and_Results"
global WealthData "/Users/hhadah/Dropbox/EthnicFav copy/Analysis/MergedData/Wealth"
* set working directory
cd "$RegressionResults"

* open data set
use "$WealthData/DHS_Wealth.dta"
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
label var wealthq "Wealth"
********************************************************************************
* gen coethnic varialbe similar to F&R 
gen coethnic = (coethnic_4 + coethnic_3 + coethnic_2 + coethnic_1)/4
label var coethnic "Coethnic"
* average polity2 score for the 7 years 
gen Polity = (polity2_4 + polity2_3 + polity2_2 + polity2_1)/4
label var Polity "Average polity over the last 4 years."
* interaction between polity and edu
gen inter_polity2_coethnic = Polity * coethnic
label var inter_polity2_coethnic "\textit{Polity}$\times$\textit{Coethnic Leader}"

********************************************************************************
* democratic groups
gen Democracy = 0
replace Democracy = 1 if Polity<=9 & Polity>=6

gen Anocracy = 0
replace Anocracy = 1 if Polity>=-5 & Polity<=5
// gen OpenAnocracy = 0
// replace OpenAnocracy = 1 if Polity>=1 & Polity<=5
//
// gen ClosedAnocracy = 0
// replace ClosedAnocracy = 1 if Polity<=0 & Polity>=-5

gen Autocracy = 0
replace Autocracy = 1 if Democracy == 0 & Anocracy == 0

// gen Failed_or_Occupied = 0
// replace Failed_or_Occupied = 1 if Polity == .
********************************************************************************
* generate interaction terms between the groups and coethnicity
gen inter_Democracy_coethnic = Democracy*coethnic
gen inter_Anocracy_coethnic = Anocracy*coethnic
// gen inter_OpenAnocracy_coethnic = OpenAnocracy*coethnic
// gen inter_ClosedAnocracy_coethnic = ClosedAnocracy*coethnic
gen inter_Autocracy_coethnic = Autocracy*coethnic
// gen inter_FailedOccupied_coethnic = Failed_or_Occupied*coethnic
label var inter_Democracy_coethnic "$ I_{ 10 \geq Polity IV \geq 6} \times Coethnic Leader $"
label var inter_Anocracy_coethnic "$ I_{ 5 \geq Polity IV \geq -5} \times Coethnic Leader $"
// label var inter_OpenAnocracy_coethnic "$ I_{ 5 \geq Polity IV \geq 1} \times Coethnic Leader $"
// label var inter_ClosedAnocracy_coethnic "$ I_{ 0 \geq Polity IV \geq -5} \times Coethnic Leader $"
label var inter_Autocracy_coethnic "$ I_{ -5 \geq Polity IV \geq 10} \times Coethnic Leader $"
// label var inter_FailedOccupied_coethnic "\textit{Failed state}$\times$\textit{Coethnic Leader}"
********************************************************************************
********************************************************************************
* regressions on Wealth
********************************************************************************
gen birth_year = intyear - age
* set up local variables
local DemInterCoethVars inter_Democracy_coethnic inter_Anocracy_coethnic inter_ClosedAnocracy_coethnic
local PolityGroups Democracy Anocracy ClosedAnocracy
local EthnicFEs "BeninEth1-ZimbabweEth6"
// local RegionFEs "geo_bj1996_2011 geo_bf2003_2010 geo_bi2010_2016 geo_cm1991_2011 geo_cd2007_2013 geo_et2000_2016 geo_gh1988_2014 geo_gn1999_2012 geo_ke1989_2014 geo_mw1992_2016 geo_ml1987_2012 geo_mz1997_2011 geo_nm1992_2013 geo_ne1992_2012 geo_ng2003_2013 geo_sn1986_2017 geo_za1998_2016 geo_ug1995_2016 geo_zm1992_2013 geo_zw1994_2015"
egen EthClusters = group(BeninEth1-ZimbabweEth6)
********************************************************************************
* Ethnic favoritism in Wealth 
* with Country-Year fixed effects,
* Age FE and 5 years groups FE
// eststo did_ethfav_ct_w: xi: reg  wealthq coethnic urban female i.cowcode_4*i.birth_year  i.age i.age5year , cluster(birth_year) noomit  
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
eststo did_ethfav_ethFE_w: 	reghdfe  	wealthq coethnic urban female 								, absorb(i.birth_year  i.age  i.EthClusters) cluster(EthClusters) noomit
eststo did_ethfav_dem_w: 	reghdfe		wealthq coethnic urban female 			if Democracy == 1	, absorb(i.birth_year  i.age  i.EthClusters) cluster(EthClusters) noomit
eststo did_ethfav_anoc_w: 	reghdfe 	wealthq coethnic urban female 			if Anocracy == 1	, absorb(i.birth_year  i.age  i.EthClusters) cluster(EthClusters) noomit  
eststo did_ethfav_autoc_w: 	reghdfe 	wealthq coethnic urban female 			if Autocracy == 1	, absorb(i.birth_year  i.age) cluster(EthClusters) noomit  
#delimit;
coefplot 	(did_ethfav_dem_w, label(Democracy))
			(did_ethfav_anoc_w, label(Anocracy)) 
			(did_ethfav_autoc_w, label(Autocracy)),
			aseq swapnames legend(off)
			title("The Co-ethnic Effect on Wealth" "with Ethnic Groups and Time Fixed Effects by Democratic Group") 
			keep(coethnic) xline(0, lcolor(red))
			msymbol(O) msize(large) levels(90)
			coeflabels(did_ethfav_dem_w = "Democracy"
					   did_ethfav_anoc_w = "Anocracy"
					   did_ethfav_autoc_w = "Autocracy");
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
// eststo did_ethfav_region_w:xi: reg  wealthq coethnic urban female i.`RegionFEs' i.birth_year   i.age i.age5year, cluster(birth_year)
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
// eststo did_dem_counttime_w: xi: reg  wealthq $DemInterCoethVars $PolityGroups urban female coethnic i.cowcode_4*i.birth_year   i.age i.age5year, cluster(birth_year) noomit  
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
eststo did_dem_eth_w: reghdfe  wealthq $DemInterCoethVars $PolityGroups urban female coethnic, absorb(i.birth_year  i.age  i.EthClusters) cluster(EthClusters) noomit
********************************************************************************
* Coethnicity and Democracy
* with Regional FE
********************************************************************************
// eststo did_dem_reg_w:  xi: reg  wealthq $DemInterCoethVars $PolityGroups urban female coethnic i.`RegionFEs' i.birth_year  i.age i.age5year , cluster(birth_year)
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
eststo did_contdem_w: reghdfe  wealthq inter_polity2_coethnic coethnic urban female Polity, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
********************************************************************************
* Democracy-Diictatorship index regression
********************************************************************************
* average democracy-diictatorship index
gen Democracy_dem_dic = (democracy_4 + democracy_3 + democracy_2 + democracy_1)/4
label var Democracy_dem_dic "Democracy"
gen inter_dem_dic = Democracy_dem_dic*coethnic
eststo Democracy_Wdemdic: reghdfe wealthq inter_dem_dic coethnic Democracy_dem_dic urban female, absorb(i.birth_year  i.age i.EthClusters) cluster(EthClusters) noomit
