/*
This do file produces the tables
from the different regressions I ran
*/
********************************************************************************
clear
cls

* set working directory
cd "$RegressionResults"

 ********************************************************************************
 * creating tables for Ethnic Fav  results
 ********************************************************************************
 * Ethnic Favoritism with Country-Time FE
//  #delimit ;
//  esttab did_ethfav_ct did_ct_Inf did_ethfav_ct_w did_ctElectrification did_ctAccessToWater using "ethnic_fav_tab.tex", 
//  	replace label se star(* 0.10 ** 0.05 *** 0.01)
//  	s(fixedcountry fixedyear fixedcountry_year regionFE EthnicFE clusterSE Controls N,
//  	label("Country FE" "Year FE" "Country-time FE"  "Region FE" "Ethnicity FE" "Clustered SE" "Controls"  "Observations"))
// 	title("Ethnic favoritism results with time--country FE")
//  	keep(coethnic)
// 	coeflabels(coethnic Coethnic);
//  #delimit cr

 * Ethnic Favoritism with ethnic groups FE
 
 #delimit ;
 esttab did_ethfav_ethFE  did_eth_Inf did_ethfav_ethFE_w did_ethElectrification did_ethAccessToWater using "ethnic_fav_tab_ethFE.tex", 
 	replace se star(* 0.10 ** 0.05 *** 0.01) label
	addnotes("In this table, I am reporting the estimates of equation \ref{eqFR1}. I present the results of the effect of ethnic favoritism on primary school completions in column 1, infant survival in column 2, wealth quintile in column 3, electrification in column 4 and access to clean drinking water in column 4. Primary school completion is a dummy variable that is equal to one if a person completed primary school and zero otherwise. Infant survival is a dummy variable that is equal to one if an infant survived the first 12 months of life. Electrification is a dummy variable that is equal to one if a household has electricity. Finally, access to clean drinking water is an ordinal variable that has values from 1, worst water source, to 4."
     "Standard errors are clustered on ethnic groups. All results include ethnic group, time and age fixed effects.")
	s(N,
 	label("Observations"))
	title("Ethnic favoritism results.")
	keep(coethnic)
	booktabs alignment(D{.}{.}{-1})
	f b(3) se(3)
	coeflabels(coethnic Coethnic);
 #delimit cr
 
 #delimit ;
 esttab did_eth_Inf_dem did_eth_Inf_anoc did_eth_Inf_autoc demElectrification anocElectrification autocAccessToWater demAccessToWater anocAccessToWater autocAccessToWater did_ethfav_dem did_ethfav_anoc did_ethfav_autoc using "ethnic_fav_grps.tex", 
 	replace se star(* 0.10 ** 0.05 *** 0.01) label
	addnotes("In this table, I am reporting the estimates of equation \ref{eqFR1}. I present the results of the effect of ethnic favoritism on primary school completions in column 1, infant survival in column 2, wealth quintile in column 3, electrification in column 4 and access to clean drinking water in column 4. Primary school completion is a dummy variable that is equal to one if a person completed primary school and zero otherwise. Infant survival is a dummy variable that is equal to one if an infant survived the first 12 months of life. Electrification is a dummy variable that is equal to one if a household has electricity. Finally, access to clean drinking water is an ordinal variable that has values from 1, worst water source, to 4."
     "Standard errors are clustered on ethnic groups. All results include ethnic group, time and age fixed effects.")
	s(N,
 	label("Observations"))
	title("Ethnic favoritism results.")
	keep(coethnic)
	booktabs alignment(D{.}{.}{-1})
	f b(3) se(3)
	coeflabels(coethnic Coethnic);
 #delimit cr
 	
 * Ethnic Favoritism with region FE
//  #delimit ;
//  esttab did_ethfav_region  did_reg_Inf did_ethfav_region_w did_regElectrification did_regAccessToWater using "ethnic_fav_tab_regFE.tex", 
//  	replace label se star(* 0.10 ** 0.05 *** 0.01)
//  	s(fixedcountry fixedyear fixedcountry_year regionFE EthnicFE clusterSE Controls N,
// 	label("Country FE" "Year FE" "Country-time FE"    "Region FE" "Ethnicity FE" "Clustered SE" "Controls" "Observations"))
// 	title("Ethnic favoritism results with regional FE")
//  	keep(coethnic)
// 	coeflabels(coethnic Coethnic);
//  #delimit cr
 ********************************************************************************
 * creating tables for Ethnic Fav  and democracy results
 ********************************************************************************
 * Ethnic Favoritism and democracy with Country-Time FE
//  #delimit ;
//  esttab did_dem_counttime  did_demct_Inf did_dem_counttime_w did_demctElectrification did_demctAccessToWater using"ethnic_demfav_tab.tex", 
//  	replace label se star(* 0.10 ** 0.05 *** 0.01)
//  	s(fixedcountry fixedyear fixedcountry_year regionFE EthnicFE clusterSE Controls N,
//  	label("Country FE" "Year FE" "Country-time FE"    "Region FE" "Ethnicity FE" "Clustered SE" "Controls" "Observations"))
// 	title("Ethnic favoritism and democracy results with time--country FE")
// 	keep($DemInterCoethVars coethnic)
// 	coeflabels(inter_Democracy_coethnic " \$Democracy \times Coethnic\$ " inter_OpenAnocracy_coethnic "\$Open Anocracy \times Coethnic\$" inter_ClosedAnocracy_coethnic "\$Closed Anocracy \times Coethnic\$" coethnic Coethnic);
//  #delimit cr
 	
 * Ethnic Favoritism and democracy with ethnic groups FE
//  #delimit ;
//  esttab did_dem_eth did_demeth_Inf did_dem_eth_w did_demethElectrification did_demethAccessToWater using "ethnic_demfav_tab_ethFE.tex", 
//  	replace label se star(* 0.10 ** 0.05 *** 0.01)
//  	s(N,
//  	label("Observations"))
// 	title("Ethnic favoritism and democracy results with ethnic groups FE")
// 	keep($DemInterCoethVars coethnic)
// 	coeflabels(inter_Democracy_coethnic "\$Democracy \times Coethnic\$" inter_OpenAnocracy_coethnic "\$Open Anocracy \times Coethnic\$" inter_ClosedAnocracy_coethnic "\$Closed Anocracy \times Coethnic\$" coethnic Coethnic);
//  #delimit cr
 
 #delimit ;
 esttab did_dem_eth did_demeth_Inf did_dem_eth_w did_demethElectrification did_demethAccessToWater using "ethnic_demfav_tab_ethFE.tex", 
 	replace se star(* 0.10 ** 0.05 *** 0.01) label
	addnotes("In this table, I am reporting the estimates of equation \ref{eq2}. I present the results of the interaction between the coethnic variable and \textit{Polity IV } groups on primary school completions in column 1, infant survival in column 2, wealth quintile in column 3, electrification in column 4 and access to clean drinking water in column 4. Primary school completion is a dummy variable that is equal to one if a person completed primary school and zero otherwise. Infant survival is a dummy variable that is equal to one if an infant survived the first 12 months of life. Electrification is a dummy variable that is equal to one if a household has electricity. Finally, access to clean drinking water is an ordinal variable that has values from 1, worst water source, to 4."
     "Democracies have a \textit{Polity IV } $\in [10, 5]$, anocracies have a \textit{Polity IV } $\in [4, -5]$ and autocracies, the omitted group, have a \textit{Polity IV } $<-5$."
	 "Standard errors are clustered on ethnic groups. All results include ethnic group, time and age fixed effects.")
	s(N,
 	label("Observations"))
	title("Ethnic favoritism and democracy results.")
	keep($DemInterCoethVars coethnic)
	booktabs alignment(D{.}{.}{-1})
	f b(3) se(3)
	coeflabels(inter_Democracy_coethnic "\$Democracy \times Coethnic\$" inter_Anocracy_coethnic "\$ Anocracy \times Coethnic\$" coethnic Coethnic);
 #delimit cr
 
 * Ethnic Favoritism and  Democracy with region FE
//  #delimit ;
//  esttab did_dem_reg  did_demreg_Inf did_dem_reg_w did_demregElectrification did_demregAccessToWater using "ethnic_demfav_tab_regFE.tex", 
//  	replace label se star(* 0.10 ** 0.05 *** 0.01)
//  	s(fixedcountry fixedyear fixedcountry_year regionFE EthnicFE clusterSE Controls N,
//  	label("Country FE" "Year FE" "Country-time FE"    "Region FE" "Ethnicity FE" "Clustered SE" "Controls" "Observations"))
// 	title("Ethnic favoritism and democracy results with regional FE")
// 	keep($DemInterCoethVars coethnic)
// 	coeflabels(inter_Democracy_coethnic "\$Democracy \times Coethnic\$" inter_OpenAnocracy_coethnic "\$Open Anocracy \times Coethnic\$" inter_ClosedAnocracy_coethnic "\$Closed Anocracy \times Coethnic\$" coethnic Coethnic);
//  #delimit cr
 	
 * Ethnic Favoritism and  cont Democracy measure
 #delimit ;
 esttab did_contdem did_contdem_Inf did_contdem_w did_contdemElectrification did_contdemAccessToWater using "ethnic_demfav_cont.tex", 
 	replace se star(* 0.10 ** 0.05 *** 0.01) label
	addnotes("In this table, I am reporting the estimates of equation \ref{eq1}. I present the results of the interaction between the coethnic variable and \textit{Polity IV } groups on primary school completions in column 1, infant survival in column 2, wealth quintile in column 3, electrification in column 4 and access to clean drinking water in column 4. Primary school completion is a dummy variable that is equal to one if a person completed primary school and zero otherwise. Infant survival is a dummy variable that is equal to one if an infant survived the first 12 months of life. Electrification is a dummy variable that is equal to one if a household has electricity. Finally, access to clean drinking water is an ordinal variable that has values from 1, worst water source, to 4."
     "\textit{Polity IV } score in this specification is continuous. It takes values that range from most autocratic $-10$ to most democratic $10$."
	 "Standard errors are clustered on ethnic groups. All results include ethnic group, time and age fixed effects.")
 	s(N,
 	label("Observations"))
	title("Ethnic favoritism and continuous democracy measure results.") 	
	booktabs alignment(D{.}{.}{-1})
	f b(3) se(3)
	keep(inter_polity2_coethnic coethnic)
	coeflabels(inter_ComPrim_polity2 "\$Polity \times Coethnic\$" coethnic Coethnic);
 #delimit cr
 
 * Ethnic Favoritism and  Democracy-Dictatorship measure
 #delimit ;
 esttab Democracy_Edudemdic Democracy_Infdemdic Democracy_Wdemdic demdicElectrification demdicAccessToWater using "ethnic_demdic_ctFE.tex", 
 	replace se star(* 0.10 ** 0.05 *** 0.01) label
	addnotes("In this table, I am reporting the estimates of equation \ref{eqFR1}. I present the results of the interaction between the coethnic variable and \textit{Polity IV } groups on primary school completions in column 1, infant survival in column 2, wealth quintile in column 3, electrification in column 4 and access to clean drinking water in column 4. Primary school completion is a dummy variable that is equal to one if a person completed primary school and zero otherwise. Infant survival is a dummy variable that is equal to one if an infant survived the first 12 months of life. Electrification is a dummy variable that is equal to one if a household has electricity. Finally, access to clean drinking water is an ordinal variable that has values from 1, worst water source, to 4."
     "In this specification, I used the Democracy-Dictatorship index as a measure for checks and balances. The Democracy-Dictatorship index is an indicator variable that is equal to 1 if a country is democratic and zero otherwise."
	 "Standard errors are clustered on ethnic groups. All results include ethnic group, time and age fixed effects.")
	s(N,
 	label("Observations"))
 	title("Ethnic favoritism and Democracy-Dictatorship index results.") 	
	booktabs alignment(D{.}{.}{-1})
	f b(3) se(3)
	keep(inter_dem_dic coethnic)
	coeflabels(inter_dem_dic "\$D-D Index \times Coethnic\$" coethnic Coethnic);
 #delimit cr

* Graphs
// coefplot (did_ethfav_ct, label(Completed Primary School)) (did_ct_Inf, label(Infant mortality)) (did_ethfav_ct_w, label(Wealth)) (did_ctElectrification, label(Electrification)) (did_ctAccessToWater, label(Access to water)), vertical  xlabel(1 "Co-ethnicity") ytitle(Estimates) title("The co-ethnic effect on the outcomes of interest" "with Country-Time Fixed Effects") keep(coethnic) yline(0, lcolor(red)) legend(rows(1) pos(6) span stack) msymbol(O) msize(large) //legend(pos(1) ring(0) col(1))
// graph export coeth_ctFE.png, replace
 #delimit;
coefplot 	(did_ethfav_ethFE, label(Completed Primary School))
			(did_eth_Inf, label(Infant survival)) 
			(did_ethfav_ethFE_w, label(Wealth)) 
			(did_ethElectrification, label(Electrification)) 
			(did_ethAccessToWater, label(Access to water)),
			aseq swapnames legend(off)
			title("The co-ethnic effect on the outcomes of interest" "with Ethnic Groups and Time Fixed Effects") 
			keep(coethnic) xline(0, lcolor(red))
			msymbol(O) msize(large) levels(90)
			coeflabels(did_ethfav_ethFE = "Completed Primary School"
					   did_eth_Inf = "Infant survival"
					   did_ethfav_ethFE_w = "Wealth"
					   did_ethElectrification = "Electrification"
					   did_ethAccessToWater = "Access to water");
graph export coeth_ethFE.png, replace;
 #delimit cr

// coefplot (did_ethfav_region, label(Completed Primary School))  (did_reg_Inf, label(Infant mortality)) (did_ethfav_region_w, label(Wealth)) (did_regElectrification, label(Electrification)) (did_regAccessToWater, label(Access to water)), vertical  xlabel(1 "Co-ethnicity") ytitle(Estimates) title("The co-ethnic effect on the outcomes of interest" "with Rregions and Time Fixed Effects") keep(coethnic) yline(0, lcolor(red)) legend(rows(1) pos(6) span stack) msymbol(O) msize(large)
// graph export coeth_regFE.png, replace

// coefplot (did_dem_counttime, label(Completed Primary School))  (did_demct_Inf, label(Infant mortality)) (did_dem_counttime_w, label(Wealth)) (did_demctElectrification, label(Electrification)) (did_demctAccessToWater, label(Access to water)), vertical  xlabel(1 "I{subscript:10 {&ge} Polity IV {&ge} 6} x Coethnic" 2 "I{subscript:5 {&ge} Polity IV {&ge} 1} x Coethnic"  3 "I{subscript:0 {&ge} Polity IV {&ge} -5} x Coethnic") ytitle(Estimates) title("The democratic groups interactions with co-ethnic" "with Country-Time Fixed Effects")  keep($DemInterCoethVars) yline(0, lcolor(red)) legend(rows(1) pos(6) span stack) msymbol(O) msize(large)
// graph export coeth_dem_ctFE.png, replace

coefplot (did_dem_eth, label(Completed Primary School))  (did_demeth_Inf, label(Infant survival)) (did_dem_eth_w, label(Wealth)) (did_demethElectrification, label(Electrification)) (did_demethAccessToWater, label(Access to water)), vertical  xlabel(1 "I{subscript:10 {&ge} Polity IV {&ge} 6} x Coethnic" 2 "I{subscript:5 {&ge} Polity IV {&ge} -5} x Coethnic") ytitle(Estimates) title("The democratic groups interactions with co-ethnic" "with Ethnic Groups and Time Fixed Effects")  keep($DemInterCoethVars) yline(0, lcolor(red)) legend(rows(1) pos(6) span stack) msymbol(O) msize(large) levels(90)
graph export coeth_dem_ethFE.png, replace

/*#delimit;
coefplot 		(did_dem_eth, label(Completed Primary School))  
				(did_demeth_Inf, label(Infant survival)) 
				(did_dem_eth_w, label(Wealth)) 
				(did_demethElectrification, label(Electrification)) 
				(did_demethAccessToWater, label(Access to water)), 
				legend(off) 
				title("The democratic groups interactions with co-ethnic" "with Ethnic Groups and Time Fixed Effects")  
				keep($DemInterCoethVars) 
				xline(0, lcolor(red)) 
				msymbol(O) msize(large) levels(90) 
				groups(inter_Democracy_coethnic = "{bf:I{subscript:10 {&ge} Polity IV {&ge} 6} x Coethnic}"
				inter_Anocracy_coethnic = "{bf:I{subscript:5 {&ge} Polity IV {&ge} -5} x Coethnic}")
						coeflabels(CompletedPrimaryEdu = "Completed Primary School"
						did_eth_Inf = "Infant survival"
						did_ethfav_ethFE_w = "Wealth"
						did_ethElectrification = "Electrification"
						did_ethAccessToWater = "Access to water");
graph export coeth_dem_ethFE.png, replace

 #delimit cr*/

// coefplot (did_dem_reg, label(Completed Primary School))  (did_demreg_Inf, label(Infant mortality)) (did_dem_reg_w, label(Wealth)) (did_demregElectrification, label(Electrification)) (did_demregAccessToWater, label(Access to water)), vertical  xlabel(1 "I{subscript:10 {&ge} Polity IV {&ge} 6} x Coethnic" 2 "I{subscript:5 {&ge} Polity IV {&ge} 1} x Coethnic"  3 "I{subscript:0 {&ge} Polity IV {&ge} -5} x Coethnic") ytitle(Estimates) title("The democratic groups interactions with co-ethnic" "with Rregions and Time Fixed Effects")  keep($DemInterCoethVars) yline(0, lcolor(red)) legend(rows(1) pos(6) span stack) msymbol(O) msize(large)
// graph export coeth_dem_regFE.png, replace

coefplot (did_contdem, label(Completed Primary School))  (did_contdem_Inf, label(Infant survival)) (did_contdem_w, label(Wealth)) (did_contdemElectrification, label(Electrification)) (did_contdemAccessToWater, label(Access to water)), vertical   ytitle(Estimates) title("The Polity interactions with co-ethnic" "with Ethnic Groups and Time Fixed Effects")  keep(inter_polity2_coethnic) xlabel(1 "Polity IV x Coethnic") yline(0, lcolor(red)) legend(rows(1) pos(6) span stack) msymbol(O) msize(large) levels(90)
graph export coeth_contdem_ethFE.png, replace

coefplot (Democracy_Edudemdic, label(Completed Primary School))  (Democracy_Infdemdic, label(Infant survival)) (Democracy_Wdemdic, label(Wealth)) (demdicElectrification, label(Electrification)) (demdicAccessToWater, label(Access to water)), vertical  xlabel(1 "Democracy-Dictatorship x Coethnic") ytitle(Estimates) title("The democratic groups interactions with co-ethnic" "with Ethnic Groups and Time Fixed Effects")  keep(inter_dem_dic) yline(0, lcolor(red)) legend(rows(1) pos(6) span stack) msymbol(O) msize(large) levels(90)
graph export coeth_demdic_ctFE.png, replace
#delimit;
coefplot 	(demElectrification, label(Democracy))
			(anocElectrification, label(Anocracy)) 
			(autocElectrification, label(Autocracy)),
			aseq swapnames legend(off)
			title("The Co-ethnic Effect on Electrification" "with Ethnic Groups and Time Fixed Effects by Democratic Group") 
			keep(coethnic) xline(0, lcolor(red))
			msymbol(O) msize(large) levels(90)
			coeflabels(demElectrification = "Democracy"
					   anocElectrification = "Anocracy"
					   autocElectrification = "Autocracy");
graph export coeth_byGroups4.png, replace;
 #delimit cr
 
 #delimit;
coefplot 	(demAccessToWater, label(Democracy))
			(anocAccessToWater, label(Anocracy)) 
			(autocAccessToWater, label(Autocracy)),
			aseq swapnames legend(off)
			title("The Co-ethnic Effect on Access To Clean Drinking Water" "with Ethnic Groups and Time Fixed Effects by Democratic Group") 
			keep(coethnic) xline(0, lcolor(red))
			msymbol(O) msize(large) levels(90)
			coeflabels(demAccessToWater = "Democracy"
					   anocAccessToWater = "Anocracy"
					   autocAccessToWater = "Autocracy");
graph export coeth_byGroups5.png, replace;
 #delimit cr
 
clear
cls
 
