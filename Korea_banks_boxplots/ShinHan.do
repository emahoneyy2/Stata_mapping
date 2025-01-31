clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots\bank_specific\Shin Han"
*local tab roe total_cap_ratio rwd sbl_loans fxloans_totloans fxdep_totdep totaldep_totallib borr_bonds_lib totloans_totdep totloans_totassets nim LLrate IIrate IErate eq_assets nfci_totfinasset roa
*local tab nfci_totfinasset
local tab nim IIrate IErate total_cap_ratio eq_assets fxdep_totdep borr_bonds_lib sbl_loans
foreach var of local tab {
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("`var'") firstrow
reshape long F, i(time) j(bank) string
gen num=subinstr(bank,"I","",.)
destring num, replace
gen type="Nationwide" if num==1 | num==2 | num==3 | num==4 | num==5 | num==6 | num==7 | num==8
replace type="Regional" if num==9 | num==10 | num==11 | num==12 | num==13 | num==14
replace type="Specialized" if num==15 | num==16 | num==17 | num==18 | num==19
gen x="`var'"
drop if x=="nfci_totfinasset" & num==8
drop x
reshape wide F, i(time bank) j(type) string
rename F* *
gen t=time
gen date=quarterly(time,"YQ")
format date %tq
drop time
rename date time
*keep if time>tq(2004Q3)
label var Nationwide "Nationwide Banks"
label var Regional "Regional Banks"
label var Specialized "Specialized Banks"
rename Nationwide x_Nationwide
rename Regional x_Regional
rename Specialized x_Specialized
reshape long x, i(bank time) j(type) string
replace type=subinstr(type,"_","",.)


local y x
foreach x of local y {
egen `x'_p05=pctile(`x'), p(05) by(type time)
egen `x'_p95=pctile(`x'), p(95) by(type time)
egen `x'_med=pctile(`x'), p(50) by(type time)
egen `x'_loq=pctile(`x'), p(25) by(type time)
egen `x'_upq=pctile(`x'), p(75) by(type time)
egen `x'_iqr=iqr(`x'), by(type time)
egen `x'_upper=max(min(`x', `x'_upq + 1.5 * `x'_iqr)), by(type time)
egen `x'_lower=min(max(`x', `x'_loq - 1.5 * `x'_iqr)), by(type time)
egen `x'_mean=mean(`x'), by(time)
capture egen SHIN_HAN=mean(`x'), by(time num)
replace SHIN_HAN=. if num!=2
}
rename SHIN_HAN x_SHIN_HAN
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
rename x_SHIN_HAN SHIN_HAN
twoway rbar x_med x_upq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_upq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_upq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rbar x_med x_loq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_loq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_loq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rspike x_loq x_p05 date if type=="Regional", pstyle(p2) || ///
rspike x_loq x_p05 date if type=="Nationwide", pstyle(p1) || ///
rspike x_loq x_p05 date if type=="Specialized", pstyle(p3) || ///
rspike x_upq x_p95 date if type=="Nationwide", pstyle(p1) || ///
rspike x_upq x_p95 date if type=="Regional", pstyle(p2) || ///
rspike x_upq x_p95 date if type=="Specialized", pstyle(p3) ///
xla(1 "2000" 13 "2001" 25 "2002" 37 "2003" 49 "2004" 61 "2005" 73 "2006" 85 "2007" 97 "2008" 109 "2009" ///
 121 "2010" 133 "2011" 145 "2012" 157 "2013" 169 "2014" 181 "2015" 193 "2016" 205 "2017" 217 "2018") ytitle(`var', axis(1)) || ///
line SHIN_HAN date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized" 10 "SHIN_HAN"))
*graph save `var'_v2, replace
graph export `var'.png, replace
}

*****************************************************************************//
*								SHORT VARS
*****************************************************************************//
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("cet1_rwa") firstrow
reshape long F, i(time) j(bank) string
gen num=subinstr(bank,"I","",.)
destring num, replace
gen type="Nationwide" if num==1 | num==2 | num==3 | num==4 | num==5 | num==6 | num==7 | num==8
replace type="Regional" if num==9 | num==10 | num==11 | num==12 | num==13 | num==14
replace type="Specialized" if num==15 | num==16 | num==17 | num==18 | num==19
reshape wide F, i(time bank) j(type) string
rename F* *
gen t=time
gen date=quarterly(time,"YQ")
format date %tq
keep if date>=tq(2013q4)
drop time
rename date time
label var Nationwide "Nationwide Banks"
label var Regional "Regional Banks"
label var Specialized "Specialized Banks"
rename Nationwide x_Nationwide
rename Regional x_Regional
rename Specialized x_Specialized
reshape long x, i(bank time) j(type) string
replace type=subinstr(type,"_","",.)


local y x
foreach x of local y {
egen `x'_p05=pctile(`x'), p(05) by(type time)
egen `x'_p95=pctile(`x'), p(95) by(type time)
egen `x'_med=pctile(`x'), p(50) by(type time)
egen `x'_loq=pctile(`x'), p(25) by(type time)
egen `x'_upq=pctile(`x'), p(75) by(type time)
egen `x'_iqr=iqr(`x'), by(type time)
egen `x'_upper=max(min(`x', `x'_upq + 1.5 * `x'_iqr)), by(type time)
egen `x'_lower=min(max(`x', `x'_loq - 1.5 * `x'_iqr)), by(type time)
egen `x'_mean=mean(`x'), by(time)
capture egen SHIN_HAN=mean(`x'), by(time num)
replace SHIN_HAN=. if num!=2
}
rename SHIN_HAN x_SHIN_HAN
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
rename x_SHIN_HAN SHIN_HAN
twoway rbar x_med x_upq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_upq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_upq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rbar x_med x_loq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_loq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_loq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rspike x_loq x_p05 date if type=="Regional", pstyle(p2) || ///
rspike x_loq x_p05 date if type=="Nationwide", pstyle(p1) || ///
rspike x_loq x_p05 date if type=="Specialized", pstyle(p3) || ///
rspike x_upq x_p95 date if type=="Nationwide", pstyle(p1) || ///
rspike x_upq x_p95 date if type=="Regional", pstyle(p2) || ///
rspike x_upq x_p95 date if type=="Specialized", pstyle(p3) ///
xla(4 "2014" 16 "2015" 28 "2016" 40 "2017" 52 "2018") ytitle(cet1_rwa, axis(1)) || ///
line SHIN_HAN date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized" 10 "SHIN_HAN"))
*graph save cet1_rwa_v2, replace
graph export cet1_rwa.png, replace

*line x_mean date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))

**********************************************************
**********************************************************
**********************************************************
**********************************************************
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("llp_loans") firstrow
reshape long F, i(time) j(bank) string
gen num=subinstr(bank,"I","",.)
destring num, replace
gen type="Nationwide" if num==1 | num==2 | num==3 | num==4 | num==5 | num==6 | num==7 | num==8
replace type="Regional" if num==9 | num==10 | num==11 | num==12 | num==13 | num==14
replace type="Specialized" if num==15 | num==16 | num==17 | num==18 | num==19
reshape wide F, i(time bank) j(type) string
rename F* *
gen t=time
gen date=quarterly(time,"YQ")
format date %tq
drop time
rename date time
keep if time>tq(2008Q1)
label var Nationwide "Nationwide Banks"
label var Regional "Regional Banks"
label var Specialized "Specialized Banks"
rename Nationwide x_Nationwide
rename Regional x_Regional
rename Specialized x_Specialized
reshape long x, i(bank time) j(type) string
replace type=subinstr(type,"_","",.)


local y x
foreach x of local y {
egen `x'_p05=pctile(`x'), p(05) by(type time)
egen `x'_p95=pctile(`x'), p(95) by(type time)
egen `x'_med=pctile(`x'), p(50) by(type time)
egen `x'_loq=pctile(`x'), p(25) by(type time)
egen `x'_upq=pctile(`x'), p(75) by(type time)
egen `x'_iqr=iqr(`x'), by(type time)
egen `x'_upper=max(min(`x', `x'_upq + 1.5 * `x'_iqr)), by(type time)
egen `x'_lower=min(max(`x', `x'_loq - 1.5 * `x'_iqr)), by(type time)
egen `x'_mean=mean(`x'), by(time)
capture egen SHIN_HAN=mean(`x'), by(time num)
replace SHIN_HAN=. if num!=2
}
rename SHIN_HAN x_SHIN_HAN
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
rename x_SHIN_HAN SHIN_HAN

twoway rbar x_med x_upq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_upq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_upq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rbar x_med x_loq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_loq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_loq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rspike x_loq x_p05 date if type=="Regional", pstyle(p2) || ///
rspike x_loq x_p05 date if type=="Nationwide", pstyle(p1) || ///
rspike x_loq x_p05 date if type=="Specialized", pstyle(p3) || ///
rspike x_upq x_p95 date if type=="Nationwide", pstyle(p1) || ///
rspike x_upq x_p95 date if type=="Regional", pstyle(p2) || ///
rspike x_upq x_p95 date if type=="Specialized", pstyle(p3) ///
xla(1 "2008" 13 "2009" 25 "2010" 37 "2011" 49 "2012" 61 "2013" 73 "2014" 85 "2015" 97 "2016" 109 "2017" 121 "2018") ytitle(llp_loans, axis(1)) || ///
line SHIN_HAN date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized" 10 "SHIN_HAN"))
*graph save llp_loans_v2, replace
graph export llp_loans.png, replace


**************************************************************
************NO SPECIALIZED
**************************************************************
clear
local tab rwd fxloans_totloans LLrate roa
*local tab roa
foreach var of local tab {
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("`var'") firstrow
reshape long F, i(time) j(bank) string
gen num=subinstr(bank,"I","",.)
destring num, replace
gen type="Nationwide" if num==1 | num==2 | num==3 | num==4 | num==5 | num==6 | num==7 | num==8
replace type="Regional" if num==9 | num==10 | num==11 | num==12 | num==13 | num==14
drop if num==15 | num==16 | num==17 | num==18 | num==19
reshape wide F, i(time bank) j(type) string
rename F* *
gen t=time
gen date=quarterly(time,"YQ")
format date %tq
drop time
rename date time
*keep if time>tq(2004Q3)
label var Nationwide "Nationwide Banks"
label var Regional "Regional Banks"
*label var Specialized "Specialized Banks"
rename Nationwide x_Nationwide
rename Regional x_Regional
*rename Specialized x_Specialized
reshape long x, i(bank time) j(type) string
replace type=subinstr(type,"_","",.)


local y x
foreach x of local y {
egen `x'_p05=pctile(`x'), p(05) by(type time)
egen `x'_p95=pctile(`x'), p(95) by(type time)
egen `x'_med=pctile(`x'), p(50) by(type time)
egen `x'_loq=pctile(`x'), p(25) by(type time)
egen `x'_upq=pctile(`x'), p(75) by(type time)
egen `x'_iqr=iqr(`x'), by(type time)
egen `x'_upper=max(min(`x', `x'_upq + 1.5 * `x'_iqr)), by(type time)
egen `x'_lower=min(max(`x', `x'_loq - 1.5 * `x'_iqr)), by(type time)
egen `x'_mean=mean(`x'), by(time)
capture egen SHIN_HAN=mean(`x'), by(time num)
replace SHIN_HAN=. if num!=2
}
rename SHIN_HAN x_SHIN_HAN
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
rename x_SHIN_HAN SHIN_HAN
twoway rbar x_med x_upq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_upq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_upq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rbar x_med x_loq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.8) || ///
rbar x_med x_loq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.8) || ///
rbar x_med x_loq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.8) || ///
rspike x_loq x_p05 date if type=="Regional", pstyle(p2) || ///
rspike x_loq x_p05 date if type=="Nationwide", pstyle(p1) || ///
rspike x_loq x_p05 date if type=="Specialized", pstyle(p3) || ///
rspike x_upq x_p95 date if type=="Nationwide", pstyle(p1) || ///
rspike x_upq x_p95 date if type=="Regional", pstyle(p2) || ///
rspike x_upq x_p95 date if type=="Specialized", pstyle(p3) ///
 xla(1 "2000" 9 "2001" 17 "2002" 25 "2003" 33 "2004" 41 "2005" 49 "2006" 57 "2007" 65 "2008" 73 "2009" ///
 81 "2010" 89 "2011" 97 "2012" 105 "2013" 113 "2014" 121 "2015" 129 "2016" 137 "2017" 145 "2018") ytitle(`var', axis(1)) || ///
line SHIN_HAN date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 10 "SHIN_HAN"))
*graph save `var'_nospecialized, replace
graph export `var'_nospecialized_.png, replace
}


