clear
*Change this path to your data path, and create a subfolder "Map_output". You may need to install the maptile function.
global path1 Z:\Elizabeth\
cd "$path1"
use "$path1\Florida_all_sum.dta" 

rename FL2_PropertyZip zipcode
rename nobs nobs_all
save FL1, replace
clear
use "$path1\Florida_foreign_sum.dta" 
rename nobs nobs_foreign
rename PropertyZip zipcode
rename mean_all mean_foreign
rename sum_all sum_foreign
save FL2, replace
clear
use FL1
merge 1:1 zipcode year using FL2
gen foreign_salesprice_pct=sum_foreign/sum_all*100
gen foreign_nobs_pct=nobs_foreign/nobs_all*100


rename zipcode zip5
destring year, replace

gen time_group=1 if year==1994 | year==1995 | year==1996 | year==1997 | year==1998
replace time_group=2 if year==1999 | year==2000 | year==2001 | year==2002 | year==2003
replace time_group=3 if year==2004 | year==2005 | year==2006 | year==2007 | year==2008
replace time_group=4 if year==2009 | year==2010 | year==2011 | year==2012 | year==2013
replace time_group=5 if year==2014 | year==2015 | year==2016 | year==2017 | year==2018

bysort time_group: summarize foreign_salesprice_pct, detail
bysort time_group: summarize foreign_nobs_pct, detail


collapse(sum) sum_foreign sum_all nobs_all nobs_foreign, by(time_group zip5)
gen foreign_salesprice_pct=sum_foreign/sum_all*100
gen foreign_nobs_pct=nobs_foreign/nobs_all*100
bysort time_group: summarize foreign_salesprice_pct, detail
bysort time_group: summarize foreign_nobs_pct, detail
summarize foreign_nobs_pct, detail

preserve
keep if time_group==1
maptile foreign_salesprice_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("1994-1998") legend(pos(8) label(2 "<.16%") label(3 ".16%-.78%") label(4 ".78%-2.5%") label(5 "2.5%-4.6%") label(6 "4.6%-28%") label(7 ">28%"))) cutvalues(.16 .78 2.5 4.6 28)
cd "$path1\Map_output"
graph save florida_9498, replace
restore
preserve
keep if time_group==2
maptile foreign_salesprice_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("1999-2003") legend(pos(8) label(2 "<.16%") label(3 ".16%-.78%") label(4 ".78%-2.5%") label(5 "2.5%-4.6%") label(6 "4.6%-28%") label(7 ">28%"))) cutvalues(.16 .78 2.5 4.6 28)
cd "$path1\Map_output"
graph save florida_9903, replace
restore
preserve
keep if time_group==3
maptile foreign_salesprice_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("2004-2008") legend(pos(8) label(2 "<.16%") label(3 ".16%-.78%") label(4 ".78%-2.5%") label(5 "2.5%-4.6%") label(6 "4.6%-28%") label(7 ">28%"))) cutvalues(.16 .78 2.5 4.6 28)
cd "$path1\Map_output"
graph save florida_0408, replace
restore
preserve
keep if time_group==4
maptile foreign_salesprice_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("2009-2013") legend(pos(8) label(2 "<.16%") label(3 ".16%-.78%") label(4 ".78%-2.5%") label(5 "2.5%-4.6%") label(6 "4.6%-28%") label(7 ">28%"))) cutvalues(.16 .78 2.5 4.6 28)
cd "$path1\Map_output"
graph save florida_0913, replace
restore
preserve
keep if time_group==5
maptile foreign_salesprice_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("2014-2018") legend(pos(8) label(2 "<.16%") label(3 ".16%-.78%") label(4 ".78%-2.5%") label(5 "2.5%-4.6%") label(6 "4.6%-28%") label(7 ">28%"))) cutvalues(.16 .78 2.5 4.6 28)
cd "$path1\Map_output"
graph save florida_1418, replace
restore
preserve
keep if time_group==1
maptile foreign_nobs_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("1994-1998") legend(pos(8) label(2 "<.22%") label(3 ".22%-.91%") label(4 ".91%-2.8%") label(5 "2.8%-4.9%") label(6 "4.9%-27%") label(7 ">27%"))) cutvalues(.22 .91 2.8 4.9 27)
graph save florida_obs_9498, replace
restore
preserve
keep if time_group==2
maptile foreign_nobs_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("1999-2003") legend(pos(8) label(2 "<.22%") label(3 ".22%-.91%") label(4 ".91%-2.8%") label(5 "2.8%-4.9%") label(6 "4.9%-27%") label(7 ">27%"))) cutvalues(.22 .91 2.8 4.9 27)
cd "$path1\Map_output"
graph save florida_obs_9903, replace
restore
preserve
keep if time_group==3
maptile foreign_nobs_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("2004-2008") legend(pos(8) label(2 "<.22%") label(3 ".22%-.91%") label(4 ".91%-2.8%") label(5 "2.8%-4.9%") label(6 "4.9%-27%") label(7 ">27%"))) cutvalues(.22 .91 2.8 4.9 27)
cd "$path1\Map_output"
graph save florida_obs_0408, replace
restore
preserve
keep if time_group==4
maptile foreign_nobs_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("2009-2013") legend(pos(8) label(2 "<.22%") label(3 ".22%-.91%") label(4 ".91%-2.8%") label(5 "2.8%-4.9%") label(6 "4.9%-27%") label(7 ">27%"))) cutvalues(.22 .91 2.8 4.9 27)
cd "$path1\Map_output"
graph save florida_obs_0913, replace
restore
preserve
keep if time_group==5
maptile foreign_nobs_pct, geo(zip5) mapif(zip5>=32025 & zip5<=34986) ///
legformat(%12.2f) twopt(title("2014-2018") legend(pos(8) label(2 "<.22%") label(3 ".22%-.91%") label(4 ".91%-2.8%") label(5 "2.8%-4.9%") label(6 "4.9%-27%") label(7 ">27%"))) cutvalues(.22 .91 2.8 4.9 27)
cd "$path1\Map_output"
graph save florida_obs_1418, replace
restore



