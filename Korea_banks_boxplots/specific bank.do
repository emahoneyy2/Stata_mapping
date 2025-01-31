clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
local tab roe total_cap_ratio rwd sbl_loans fxloans_totloans fxdep_totdep totaldep_totallib borr_bonds_lib totloans_totdep totloans_totassets nim LLrate IIrate IErate eq_assets nfci_totfinasset roa
*local tab nfci_totfinasset
*foreach var of local tab {
*****************************************************************************//
*								SAND BOX
*****************************************************************************//
clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
local tab roe total_cap_ratio rwd sbl_loans llp_loans fxloans_totloans fxdep_totdep totaldep_totallib borr_bonds_lib totloans_totdep totloans_totassets nim LLrate IIrate IErate eq_assets nfci_totfinasset roa
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("nim") firstrow
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
capture egen Kookmin=mean(`x'), by(time num)
replace Kookmin=. if num!=1
}
rename Kookmin x_Kookmin
sort t type
collapse(lastnm) x_*, by(type time t)
sort t type
gen id=_n
rename id division2
encode t, gen(t3)
label val division2 t3
rename division2 date
sort t type
rename x_Kookmin Kookmin
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
line Kookmin date, lcolor(yellow) lwidth(.6) xsize(12) ysize(3) plotregion(fcolor(white)) graphregion(fcolor(white)) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))
