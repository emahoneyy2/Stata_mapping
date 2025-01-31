clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
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
keep if time>tq(2004Q3)
label var Nationwide "Nationwide Banks"
label var Regional "Regional Banks"
label var Specialized "Specialized Banks"
graph box Nationwide Regional Specialized, over(t, label(angle(vertical))) xsize(12) ysize(3) marker(1)
graph

local tab roe total_cap_ratio cet1_rwa rwd sbl_loans llp_loans fxloans_totloans fxdep_totdep totaldep_totallib borr_bonds_lib totloans_totdep totloans_totassets nim LLrate IIrate IErate eq_assets nfci_totfinasset roa
foreach var of local tab {
clear
import excel "Q:\DATA\AISU\Elizabeth\Korea\FISIS_Inputs_for_Boxplots.xlsx", sheet("`var'") firstrow
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
keep if time>tq(2004Q3)
label var Nationwide "Nationwide Banks"
label var Regional "Regional Banks"
label var Specialized "Specialized Banks"
graph box Nationwide Regional Specialized, nooutsides over(t, label(angle(vertical))) xsize(12) ysize(3) marker(1)
graph save `var'_v1, replace
}




*graph box Specialized, over(time)


stripplot Nationwide, over(t) box(barw(0.1)) pct(0.1) boffset(-0.15)  vertical stack height(0.4)

local y Nationwide Regional Specialized
foreach x of local y {
egen `x'_p05=pctile(`x'), p(05) by(time)
egen `x'_p95=pctile(`x'), p(95) by(time)
egen `x'_med=pctile(`x'), p(5) by(time)
egen `x'_loq=pctile(`x'), p(25) by(time)
egen `x'_upq=pctile(`x'), p(75) by(time)
egen `x'_iqr=iqr(`x'), by(time)
egen `x'_upper=max(min(`x', `x'_upq + 1.5 * `x'_iqr)), by(time)
egen `x'_lower=min(max(`x', `x'_loq - 1.5 * `x'_iqr)), by(time)
egen `x'_mean=mean(`x'), by(time)
}


twoway rbar Nationwide_med Nationwide_upq time,  ///
rbar Nationwide_med Nationwide_loq time, ///
rspike Nationwide_upq Nationwide_upper time, ///
rspike Nationwide_loq Nationwide_lower time, ///
rcap Nationwide_upper Nationwide_upper time, msize(*2) /// 
rcap Nationwide_lower Nationwide_lower time, msize(*2) ///
scatter Nationwide time if !inrange(Nationwide, Nationwide_lower, Nationwide_upper), ms(Oh) mla(country) ///
legend(off) ///
xla(1 " "Europe and" "Central Asia" " 2 "North America" 3 "South America", ///
noticks) yla(, ang(h)) ytitle(Life expectancy (years)) xtitle("")


encode t, gen (t2)

twoway rbar Nationwide_med Nationwide_upq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Nationwide_med Nationwide_loq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rspike Nationwide_upq Nationwide_p95 t2, pstyle(p1) || ///
rspike Nationwide_loq Nationwide_p05 t2, pstyle(p1) || /// 
rcap Nationwide_upper Nationwide_p95 t2, pstyle(p1) msize(*.5) || ///
rcap Nationwide_lower Nationwide_p05 t2, pstyle(p1) msize(*.5) xsize(12) ysize(3) yline(.1)



twoway rbar Nationwide_med Nationwide_upq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Regional_med Regional_upq t2, pstyle(p5) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Nationwide_med Nationwide_loq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Regional_med Regional_loq t2, pstyle(p5) blc(gs15) bfc(gs8) barw(0.4) || ///
rspike Nationwide_upq Nationwide_p95 t2, pstyle(p1) || ///
rspike Regional_upq Regional_p95 t2, pstyle(p5) || ///
rspike Nationwide_loq Nationwide_p05 t2, pstyle(p1) || /// 
rspike Regional_loq Regional_p05 t2, pstyle(p5) || /// 
rcap Nationwide_upper Nationwide_p95 t2, pstyle(p1) msize(*.5) || ///
rcap Regional_upper Regional_p95 t2, pstyle(p5) msize(*.5) || ///
rcap Nationwide_lower Nationwide_p05 t2, pstyle(p1) msize(*.5) || ///
rcap Regional_lower Regional_p05 t2, pstyle(p5) msize(*.5) || ///
line Nationwide_mean t2, xsize(12) ysize(3)


**********************************************************************

clear
cd "Q:\DATA\AISU\Elizabeth\Korea\boxplots"
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
keep if time>tq(2004Q3)
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
*encode t, gen (t2)
*encode type, gen(type2)


twoway rbar x_med x_upq division2, pstyle(p1) bfc(gs15) blc(gs8) barw(.8) || ///
rbar x_med x_loq division2 if type=="Nationwide", pstyle(p1) bfc(gs15) blc(gs8) barw(.8) || ///
rbar x_med x_loq division2 if type=="Regional", pstyle(p2) bfc(gs15) blc(gs8) barw(.8) || ///
rbar x_med x_loq division2 if type=="Specialized", pstyle(p3) bfc(gs15) blc(gs8) barw(.8) || ///
rspike x_loq x_p05 division2 if type=="Regional", pstyle(p2) || ///
rspike x_loq x_p05 division2 if type=="Nationwide", pstyle(p1) || ///
rspike x_loq x_p05 division2 if type=="Specialized", pstyle(p3) || ///
rspike x_upq x_p95 division2 if type=="Nationwide", pstyle(p1) || ///
rspike x_upq x_p95 division2 if type=="Regional", pstyle(p2) || ///
rspike x_upq x_p95 division2 if type=="Specialized", pstyle(p3) ///
yaxis(1 2) yla(-.5(.25).5, ang(h) axis(2)) ///
yla(-.5 "-.5" -.25 "-.25" 0 "0" .25 ".25" .5 ".5", ang(h) axis(1)) ///
xla(1(4)171) ytitle(ROE, axis(1)) || ///
line x_mean division2, xsize(12) ysize(3)


/*
twoway rbar x_med x_loq division2 if type=="Nationwide", pstyle(p1) bfc(gs10) blc(gs8) barw(.8) || ///
rbar x_med x_loq division2 if type=="Regional", pstyle(p2) bfc(gs15) blc(gs8) barw(.8) || ///
rbar x_med x_loq division2 if type=="Specialized", pstyle(p3) bfc(gs15) blc(gs8) barw(.8) || ///
rspike x_loq x_p05 division2 if type=="Regional", pstyle(p2) || ///
rspike x_loq x_p05 division2 if type=="Nationwide", pstyle(p1) || ///
rspike x_loq x_p05 division2 if type=="Specialized", pstyle(p3) || ///
rspike x_upq x_p95 division2 if type=="Nationwide", pstyle(p1) || ///
rspike x_upq x_p95 division2 if type=="Regional", pstyle(p2) || ///
rspike x_upq x_p95 division2 if type=="Specialized", pstyle(p3) ///
yaxis(1 2) yla(-.5(.25).5, ang(h) axis(2)) xsize(12) ysize(3) ///
yla(-.5 "-.5" -.25 "-.25" 0 "0" .25 ".25" .5 ".5", ang(h) axis(1)) ///
xla(1(4)171) ytitle(ROE, axis(1))
 || ///
line x division2, xsize(12) ysize(3)




xsize(12) ysize(3)







*rename type2 division2
*rename t2 region
twoway rbar x_med x_upq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar x_med x_loq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rspike x_upq x_p95 t2, pstyle(p1) || ///
rspike x_loq x_p05 t2, pstyle(p1) || /// 
rcap x_upper x_p95 t2, pstyle(p1) msize(*.5) || ///
rcap x_lower x_p05 t2, pstyle(p1) msize(*.5) xsize(12) ysize(3) yline(.1)


twoway rbar x_med x_upq division2, pstyle(p1) bfc(gs15) blc(gs8) barw(0.55) || ///
rbar x_med x_loq division2, pstyle(p1) bfc(gs15) blc(gs8) barw(0.35) || ///
rspike x_loq x_p05 division2, pstyle(p2) || ///
rspike x_upq x_p95 division2, pstyle(p2) xsize(12) ysize(3) ///
yla(-.5 "-.5" -.25 "-.25" 0 "0" .25 ".25" .5 ".5", ang(h) axis(1)) ///
xla(1(4)171)
ytitle(ROE, axis(1)) || ///
line x_mean division2, xsize(12) ysize(3)

|| ///

twoway rbar x_med x_upq division2, bfc(gs15) blc(gs8) barw(0.35) || ///
rbar x_med x_loq division2, bfc(gs15) blc(gs8) barw(0.35) || ///
rspike x_loq x_p05 division2 || ///
rspike x_upq x_p95 division2 || ///
scatter x division2 if !inrange(x, x_p05, x_p95), ms(o) legend(off) ///
xaxis(1 2) xla(1/150, valuelabel noticks grid axis(1)) ///
xla(1/9, valuelabel noticks axis(2)) xtitle("", axis(1)) xtitle("", axis(2)) ///
yaxis(1 2) yla(1(.2)2, ang(h) axis(2)) ///
yla(1 "-1" -1 "0" 1 "1" 2 "2" 3 "3", ang(h) axis(1)) ///
ytitle(mean x ({c 176}F), axis(2)) ///
ytitle(mean x ({c 176}C), axis(1)) /// 
ysc(titlegap(0) axis(1)) ysc(titlegap(0) axis(2)) ///
plotregion(lstyle(p1)) xsize(12) ysize(3)






twoway rbar x_med x_upq division2, bfc(gs15) blc(gs8) barw(0.35) || ///
rbar x_med x_loq division2, bfc(gs15) blc(gs8) barw(0.35) || ///
rspike x_loq x_p05 division2 || ///
rspike x_upq x_p95 division2 || ///
scatter x division2 if !inrange(x, x_p05, x_p95), ms(o) legend(off) ///
xaxis(1 2) xla(1/9, valuelabel noticks grid axis(1)) ///
xla(1/9, valuelabel noticks axis(2)) xtitle("", axis(1)) xtitle("", axis(2)) ///
yaxis(1 2) yla(14(18)86, ang(h) axis(2)) ///
yla(14 "-10" 32 "0" 50 "10" 68 "20" 86 "30", ang(h) axis(1)) ///
ytitle(mean x ({c 176}F), axis(2)) ///
ytitle(mean x ({c 176}C), axis(1)) /// 
ysc(titlegap(0) axis(1)) ysc(titlegap(0) axis(2)) ///
plotregion(lstyle(p1))





****************
sysuse citytemp, clear 
gen id=_n
reshape long temp, i(id) string j(month) 
rename month type
rename division t2
rename temp x
local y x
foreach x of local y {
egen `x'_p05=pctile(`x'), p(05) by(type t2)
egen `x'_p95=pctile(`x'), p(95) by(type t2)
egen `x'_med=pctile(`x'), p(5) by(type t2)
egen `x'_loq=pctile(`x'), p(25) by(type t2)
egen `x'_upq=pctile(`x'), p(75) by(type t2)
egen `x'_iqr=iqr(`x'), by(type t2)
egen `x'_upper=max(min(`x', `x'_upq + 1.5 * `x'_iqr)), by(type t2)
egen `x'_lower=min(max(`x', `x'_loq - 1.5 * `x'_iqr)), by(type t2)
egen `x'_mean=mean(`x'), by(type t2)
}

gen division2 = t2 + cond(type == "jan", -0.2, 0.2)
label val division2 division

twoway rbar x_med x_upq division2, bfc(gs15) blc(gs8) barw(0.35) || ///
rbar x_med x_loq division2, bfc(gs15) blc(gs8) barw(0.35) || ///
rspike x_loq x_p05 division2 || ///
rspike x_upq x_p95 division2 
|| ///
scatter x division2 if !inrange(x, x_p05, x_p95), ms(o) legend(off) ///
xaxis(1 2) xla(1/9, valuelabel noticks grid axis(1)) ///
xla(1/9, valuelabel noticks axis(2)) xtitle("", axis(1)) xtitle("", axis(2)) ///
yaxis(1 2) yla(14(18)86, ang(h) axis(2)) ///
yla(14 "-10" 32 "0" 50 "10" 68 "20" 86 "30", ang(h) axis(1)) ///
ytitle(mean x ({c 176}F), axis(2)) ///
ytitle(mean x ({c 176}C), axis(1)) /// 
ysc(titlegap(0) axis(1)) ysc(titlegap(0) axis(2)) 
///
plotregion(lstyle(p1))








twoway rbar x_med x_upq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar x_med x_loq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rspike x_upq x_p95 t2, pstyle(p1) || ///
rspike x_loq x_p05 t2, pstyle(p1) || /// 
rcap x_upper x_p95 t2, pstyle(p1) msize(*.5) || ///
rcap x_lower x_p05 t2, pstyle(p1) msize(*.5) xsize(12) ysize(3) yline(.1)




twoway rbar Nationwide_med Nationwide_upq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Nationwide_med Nationwide_loq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rspike Nationwide_upq Nationwide_p95 t2, pstyle(p1) || ///
rspike Nationwide_loq Nationwide_p05 t2, pstyle(p1) || /// 
rcap Nationwide_upper Nationwide_p95 t2, pstyle(p1) msize(*.5) || ///
rcap Nationwide_lower Nationwide_p05 t2, pstyle(p1) msize(*.5) xsize(12) ysize(3) yline(.1)



twoway rbar x_med x_upq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Regional_med Regional_upq t2, pstyle(p5) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Nationwide_med Nationwide_loq t2, pstyle(p1) blc(gs15) bfc(gs8) barw(0.4) || ///
rbar Regional_med Regional_loq t2, pstyle(p5) blc(gs15) bfc(gs8) barw(0.4) || ///
rspike Nationwide_upq Nationwide_p95 t2, pstyle(p1) || ///
rspike Regional_upq Regional_p95 t2, pstyle(p5) || ///
rspike Nationwide_loq Nationwide_p05 t2, pstyle(p1) || /// 
rspike Regional_loq Regional_p05 t2, pstyle(p5) || /// 
rcap Nationwide_upper Nationwide_p95 t2, pstyle(p1) msize(*.5) || ///
rcap Regional_upper Regional_p95 t2, pstyle(p5) msize(*.5) || ///
rcap Nationwide_lower Nationwide_p05 t2, pstyle(p1) msize(*.5) || ///
rcap Regional_lower Regional_p05 t2, pstyle(p5) msize(*.5) || ///
line Nationwide_mean t2, xsize(12) ysize(3)









*scatter Nationwide t2 if !inrange(Nationwide, Nationwide_lower, Nationwide_upper), ms(Oh) mla(bank)




*legend(off) xla(1 " "Europe and" "Central Asia" " 2 "North America" 3 "South America", noticks) yla(, ang(h)) ytitle(Life expectancy (years)) xtitle("")

///
rbar Nationwide_med Nationwide_loq t2 pstyle(p1) blc(gs15) bfc(gs8) barw(0.35) rspike Nationwide_upq Nationwide_upper time, pstyle(p1)


, pstyle(p1) blc(gs15) bfc(gs8) barw(0.35) ///
rbar Nationwide_med Nationwide_loq t2 pstyle(p1) blc(gs15) bfc(gs8) barw(0.35) ///
rspike Nationwide_upq Nationwide_upper time, pstyle(p1) ///
rspike Nationwide_loq Nationwide_lower time, pstyle(p1) ///
rcap Nationwide_upper Nationwide_upper time, pstyle(p1) msize(*2) ///
rcap Nationwide_lower Nationwide_lower time, pstyle(p1) msize(*2) ///
scatter Nationwide time if !inrange(Nationwide, Nationwide_lower, Nationwide_upper), ms(Oh) mla(country)
legend(off)
xla(1 " "Europe and" "Central Asia" " 2 "North America" 3 "South America", 
noticks) yla(, ang(h)) ytitle(Life expectancy (years)) xtitle("")










rbar Nationwide_med loq region, pstyle(p1) bfc(gs15) blc(gs8) barw(0.35) ||
> rspike upq p90 region, pstyle(p1) ||
> rspike loq p10 region, pstyle(p1) ||
> scatter lexp region if !inrange(lexp, p10, p90), ms(Oh) mla(country)
> mlabgap(1.5) legend(off) mlabvpos(pos)






twoway rbar Nationwide_med Nationwide_p75 time, pstyle(p1) bfc(gs15) blc(gs8) barw(0.35) ///
rbar med Nationwide_p25 time, pstyle(p1) bfc(gs15) blc(gs8) barw(0.35) ///
rspike Nationwide_p75 Nationwide_p90 time, pstyle(p1) ///
rspike Nationwide_p25 Nationwide_p10 time, pstyle(p1)
*scatter lexp region if !inrange(lexp, p10, p90), ms(Oh) mla(country)
mlabgap(1.5) legend(off) mlabvpos(pos) yla(, ang(h))

twoway rbar Nationwide_med Nationwide_p75 time, pstyle(p1) bfc(gs15) blc(gs8) barw(0.35) ||
rbar med Nationwide_p25 time, pstyle(p1) bfc(gs15) blc(gs8) barw(0.35) ||
rspike Nationwide_p75 Nationwide_p90 time, pstyle(p1) ||
rspike Nationwide_p25 Nationwide_p10 time, pstyle(p1) ||
*scatter lexp region if !inrange(lexp, p10, p90), ms(Oh) mla(country)
mlabgap(1.5) legend(off) mlabvpos(pos)
xla(1 " "Europe and" "Central Asia" " 2 "North America" 3 "South America",
noticks) yla(, ang(h)) ytitle(Life expectancy (years)) xtitle(""












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
xla(`=quarterly("2004q1","YQ")', format(%tq)) ytitle(ROE, axis(1)) || ///
line x_mean date, xsize(12) ysize(3) legend(order(1 "Nationwide" 2 "Regional" 3 "Specialized"))




