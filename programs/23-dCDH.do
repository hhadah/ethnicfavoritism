/*
This do file produces the 
dCDH regressopm
*/
********************************************************************************
clear
cls

cd "/Users/hhadah/Documents/GiT/Suicide_Idea"

* open data set
import delimited "Data/Datasets/suicide_data.csv"

* dCDH Regressions 
did_multiplegt suicide_per_hund_th fips year waitingperiods, placebo(10) breps(100) cluster(fips)


did_multiplegt suicide_per_hund_th fips year waitingperiods, robust_dynamic dynamic(20) placebo(20) breps(100) cluster(fips) firstdiff_placebo

event_plot e(estimates)#e(variances), default_look ///
	graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") ///
	title(" ") xlabel(-20(2)20)) stub_lag(Effect_#) stub_lead(Placebo_#) together
	
	
did_multiplegt suicide_per_hund_th fips year waitingperiods, placebo(1) breps(100) cluster(fips)

event_plot e(estimates)#e(variances), default_look ///
	graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") ///
	title(" ") xlabel(-20(2)20)) stub_lag(Effect_#) stub_lead(Placebo_#) together
	