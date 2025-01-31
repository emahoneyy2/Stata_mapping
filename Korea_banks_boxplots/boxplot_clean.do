clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
local tab roe total_cap_ratio rwd sbl_loans fxloans_totloans fxdep_totdep totaldep_totallib borr_bonds_lib totloans_totdep totloans_totassets nim LLrate IIrate IErate eq_assets nfci_totfinasset roa
*local tab nfci_totfinasset
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
}
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
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
 121 "2010" 133 "2011" 145 "2012" 157 "2013" 169 "2014" 181 "2015" 193 "2016" 205 "2017" 217 "2018") ytitle(`var', axis(1)) , ///
xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))
graph save `var'_v2, replace
graph export `var'_v2.png, replace
}
*line x_mean date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))

*****************************************************************************//
*								SHORT VARS
*****************************************************************************//
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
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
}
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
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
xla(4 "2014" 16 "2015" 28 "2016" 40 "2017" 52 "2018") ytitle(cet1_rwa, axis(1)) ///
, xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))
graph save cet1_rwa_v2, replace
graph export cet1_rwa_v2.png, replace

*line x_mean date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))

**********************************************************
**********************************************************
**********************************************************
**********************************************************
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
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
}
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
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
xla(1 "2008" 13 "2009" 25 "2010" 37 "2011" 49 "2012" 61 "2013" 73 "2014" 85 "2015" 97 "2016" 109 "2017" 121 "2018") ytitle(llp_loans, axis(1)) ///
, xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))
graph save llp_loans_v2, replace
graph export llp_loans_v2.png, replace

*line x_mean date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))
**********************************************************
**********************************************************
**********************************************************
**********************************************************
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("roe") firstrow
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
keep if time>tq(2007Q1)
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
}
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
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
xla(1 "2007" 13 "2008" 25 "2009" 37 "2010" 49 "2011" 61 "2012" 73 "2013" 85 "2014" 97 "2015" 109 "2016" 121 "2017" 133 "2018") ytitle(ROE, axis(1)) ///
, xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))
graph save roe_short, replace
graph export roe_short.png, replace

*****************************************************************************//
*								SAND BOX
*****************************************************************************//
clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
local tab roe total_cap_ratio rwd sbl_loans llp_loans fxloans_totloans fxdep_totdep totaldep_totallib borr_bonds_lib totloans_totdep totloans_totassets nim LLrate IIrate IErate eq_assets nfci_totfinasset roa
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("nfci_totfinasset") firstrow
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
keep if time>tq(2000Q3)
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
}
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
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
xla(1 "2000" 17 "2006" 25 "2007" 37 "2008" 49 "2009" 61 "2010" 73 "2011" 85 "2012" 97 "2013" 109 "2014" ///
 121 "2015" 133 "2016" 145 "2017" 157 "2018" 169 "2019") ytitle(ROE, axis(1)) || ///
line x_mean date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))



*****************************************************************************//
*								CREDIT UNION
*****************************************************************************//
clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"

clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("roa_creditun") firstrow
reshape long F, i(time) j(bank) string
gen num=subinstr(bank,"I","",.)
destring num, replace
gen type="Nationwide" if num==1 | num==2 | num==3 | num==4 | num==5 | num==6 | num==7 | num==8
replace type="Regional" if num==9 | num==10 | num==11 | num==12 | num==13 | num==14
replace type="Specialized" if num==15 | num==16 | num==17 | num==18 | num==19
replace type="Credit_Union" if num>=20 & num<=1337

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
rename Credit_Union x_Credit_Union
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
}
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
*keep if time>tq(2006q4)
twoway rbar x_med x_upq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.5) || ///
rbar x_med x_upq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.5) || ///
rbar x_med x_upq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.5) || ///
rbar x_med x_upq date if type=="CreditUnion", pstyle(p4) bfc(orange) bc(orange) barw(.5) || ///
rbar x_med x_loq date if type=="Nationwide", pstyle(p1) bfc(blue) bc(blue) barw(.5) || ///
rbar x_med x_loq date if type=="Regional", pstyle(p2) bfc(red) bc(red) barw(.5) || ///
rbar x_med x_loq date if type=="Specialized", pstyle(p3) bfc(green) bc(green) barw(.5) || ///
rbar x_med x_loq date if type=="CreditUnion", pstyle(p4) bfc(orange) bc(orange) barw(.5) || ///
rspike x_loq x_p05 date if type=="Regional", pstyle(p2) || ///
rspike x_loq x_p05 date if type=="Nationwide", pstyle(p1) || ///
rspike x_loq x_p05 date if type=="Specialized", pstyle(p3) || ///
rspike x_loq x_p05 date if type=="CreditUnion", pstyle(p4) || ///
rspike x_upq x_p95 date if type=="Nationwide", pstyle(p1) || ///
rspike x_upq x_p95 date if type=="Regional", pstyle(p2) || ///
rspike x_upq x_p95 date if type=="Specialized", pstyle(p3) || ///
rspike x_upq x_p95 date if type=="CreditUnion", pstyle(p4) ///
xla(5 "2001" 21 "2002" 37 "2003" 53 "2004" 74 "2005" 85 "2006" 101 "2007" 117 "2008" ///
133 "2009" 149 "2010" 165 "2011" 181 "2012" 198 "2013" 213 "2014" 229 "2015" 245 "2016" /// 
261 "2017" 278 "2018") ytitle(roa, axis(1)) , ///
xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized" 4 "Credit Union"))
graph save roa_creditunion_v2, replace
graph export roa_creditunion_v2.png, replace

*line x_mean date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized" 4 "Credit Union"))

**************************************************************
************NO SPECIALIZED
**************************************************************
clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
local tab rwd fxloans_totloans totloans_totdep LLrate roa
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
}
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
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
 81 "2010" 89 "2011" 97 "2012" 105 "2013" 113 "2014" 121 "2015" 129 "2016" 137 "2017" 145 "2018") ytitle(`var', axis(1)) , ///
xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional"))
graph save `var'_nospecialized_v2, replace
graph export `var'_nospecialized_v2.png, replace
}
