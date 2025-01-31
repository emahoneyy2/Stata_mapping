clear
global BuDA C:\Users\emahoney\Box Sync\Hong Kong Corporate Sector Vulnerability Analysis\Stata_BuDA
global data C:\Users\emahoney\Box Sync\Hong Kong Corporate Sector Vulnerability Analysis\Stata_BuDA\data
global output C:\Users\emahoney\Box Sync\Hong Kong Corporate Sector Vulnerability Analysis\Stata_BuDA\output
global results C:\Users\emahoney\Box Sync\Hong Kong Corporate Sector Vulnerability Analysis\Stata_BuDA\results
global graphs C:\Users\emahoney\Box Sync\Hong Kong Corporate Sector Vulnerability Analysis\Stata_BuDA\Graphs_stata
global charts C:\Users\emahoney\Box Sync\Hong Kong Corporate Sector Vulnerability Analysis\Stata_BuDA\Charts_excel
global assets graph save Graph C:\Users\emahoney\Box Sync\Hong Kong Corporate Sector Vulnerability Analysis\asset_dist


********************************************************************************
/// 						IMPORT AND CLEAN DATA
********************************************************************************
cd "$data"
local tabs Borrower_baseline_result Borrower_adverse_result HKG_baseline_result HKG_adverse_result CHN_baseline_result CHN_adverse_result
foreach tab of local tabs {
clear
import excel "$data\Data_newBL_Nov30.xlsx", sheet("`tab'") allstring
drop in 1/2
foreach var of varlist G-NN {
replace `var'=subinstr(`var',"01","",1)
replace `var'=subinstr(`var'," ","",.)
}

unab vars: _all
global vars `vars'
foreach j of global vars {
local try=strtoname(`j'[1])
capture rename `j' `try'
}
drop in 1

ds Company Bloomberg_ID CRI_ID Country_of_Risk Exchange Industry, not
foreach var of varlist `r(varlist)' {
destring `var', replace
rename `var' _`var'
}
drop if Bloomberg_ID==""
drop if Company=="Vlookup column index number"
reshape long _, i(Bloomberg_ID) j(date) string
rename _ PD
gen year=substr(date,4,.)
order date year
gen time=monthly(date,"MY")
order time
format time %tm
rename date date_str
rename time date

save PD_`tab', replace
}

local tabs assets_HKG assets_CHN
foreach tab of local tabs {
clear
import excel "$data\Data_newBL_Nov30.xlsx", sheet("`tab'") allstring
drop in 1/2
unab vars: _all
global vars `vars'
foreach j of global vars {
local try=strtoname(`j'[1])
capture rename `j' `try'
}
rename Total_asset_in_million_USD y_1995
local i=1996
foreach var of varlist K-AH {
rename `var' y_`i'
local ++i
}
drop in 1/4
gen y_1994=y_1995
gen y_1993=y_1995
gen y_1992=y_1995
*gen y_2019=y_2018
gen y_2020=y_2019
gen y_2021=y_2019
gen y_2022=y_2019
*EM: check this. If we add 2019 do we extend out to 2023? 
*gen y_2023=y_2018

drop if Ticker=="" | Bloomberg_ID==""
reshape long y, i(Bloomberg_ID) j(year) string
replace year=subinstr(year,"_","",.)
rename y assets
destring assets, replace force
keep assets Bloomberg_ID year
save _`tab', replace
}

clear
import excel "$data\Data_newBL_Nov30.xlsx", sheet("Real_Estate") allstring firstrow
gen real_estate=1 if IndustryGroup=="Real Estate"
rename BloombergID Bloomberg_ID
drop D E
save real_estate_list, replace


clear
use PD_Borrower_adverse_result
gen x=1
collapse(sum) x, by (Bloomberg_ID)
drop x
gen mainland_borrower=1
keep Bloomberg_ID mainland_borrower
save "$data\mainland", replace

clear
use _assets_HKG
append using _assets_CHN
merge 1:1 year Bloomberg_ID using "C:\Users\emahoney\Box Sync\Hong Kong FSAP - Corporate Sector Vulnerability Analysis\Stata_DaR\debt_2021_v3"
drop if _merge!=3
drop _merge
save assets_combo, replace
clear
local data PD_CHN_adverse_result PD_HKG_adverse_result PD_CHN_baseline_result PD_HKG_baseline_result
*local data PD_CHN_adverse_result PD_CHN_baseline_result

foreach x of local data {
cd "$data"
use `x'
merge m:1 Bloomberg_ID year using assets_combo
gen domicile="`x'"
gen domicile2="HKG" if domicile=="PD_HKG_adverse_result" | domicile=="PD_HKG_baseline_result"
replace domicile2="CHN" if domicile=="PD_CHN_baseline_result" | domicile=="PD_CHN_adverse_result"
drop domicile
rename domicile2 domicile
drop if _merge!=3
drop _merge
merge m:1 Bloomberg_ID using mainland
drop if _merge==2
drop _merge
merge m:1 Bloomberg_ID using real_estate_list
replace real_estate=0 if real_estate==.
replace Industry="Financial" if real_estate==0 & Industry=="Real estate"
*replace Industry="Financial" if IndustryGroup=="Financial"
replace Industry="Communication and technology" if IndustryGroup=="Communication and technology"
replace Industry="Consumer and utilities" if IndustryGroup=="Consumer and utilities"
replace Industry="Real estate" if IndustryGroup=="Real Estate"
drop _merge real_estate IndustryGroup Name
replace mainland_borrower=0 if mainland_borrower==.
replace Country_of_Risk="HK" if (Country_of_Risk!="CN" & Exchange=="Hong Kong")
replace Country_of_Risk="CH" if Country_of_Risk=="" & (Exchange=="China" | Exchange=="Hong Kong")
gen type=1 if (domicile=="HKG" & Country_of_Risk=="HK")
replace type=2 if ((domicile=="CHN" | domicile=="HKG") & Country_of_Risk=="CN" & Exchange=="Hong Kong")
replace type=0 if type==.
cd "$output"
save `x'_output, replace 
}


********************************************************************************
/// 						CALCULATIONS: BASELINE
********************************************************************************
cd "$output"
clear
use PD_HKG_baseline_result_output
append using PD_CHN_baseline_result_output
replace Industry="Diversified" if Bloomberg_ID=="7935807"
drop if Industry=="Diversified" | Industry=="Financial"
drop if mainland_borrower==0 & type==0

cd "$results"
preserve
drop if type==0
drop if Industry=="Diversified" | Industry=="Financial"
collapse(median) PD, by(type date)
tostring type, replace
replace type="type"+type
reshape wide PD, i(date) j(type) string
tsset date
tsline PDtype1 PDtype2
export excel using "$charts\BuDA_Charts", sheet("Baseline_type") sheetmodify firstrow(variables)
graph save "$graphs\Baseline_bytype", replace
save baseline_PD, replace
restore

cd "$results"
preserve
drop if type==0
drop if Industry=="Diversified" | Industry=="Financial"
collapse(median) PD, by(date)
export excel using "$charts\BuDA_Charts", sheet("Baseline_notype") sheetmodify firstrow(variables)
save baseline_PD_notype, replace
restore

preserve
drop if type==0
drop if Industry=="Diversified" | Industry=="Financial"
collapse(median) PD, by(type Industry date)
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
tostring type, replace
replace type="type"+type
reshape wide PD, i(date type) j(I_) string
rename PD* *
sort type date
export excel using "$charts\BuDA_Charts", sheet("Baseline_industry") sheetmodify firstrow(variables)
save baseline_PD_industry, replace
restore

preserve
drop if mainland_borrower==0
collapse(median) PD, by(date)
tsset date
tsline PD
export excel using "$charts\BuDA_Charts", sheet("Baseline_mainland") sheetmodify firstrow(variables)
graph save "$graphs\Baseline_MAINLAND", replace
save baseline_PD_mainland, replace
restore

preserve
drop if mainland_borrower==0
collapse(median) PD, by(date Industry)
egen group=group(Industry)
xtset group date
tsline PD, by(Industry)
drop group
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
reshape wide PD, i(date) j(I_) string
ren PD* *
export excel using "$charts\BuDA_Charts", sheet("Baseline_mainland_industry") sheetmodify firstrow(variables)
graph save "$graphs\Baseline_byindustry_MAINLAND", replace
save baseline_PD_industry_mainland, replace
restore


************************************************************************************************

********************************************************
* 			WEIGHTED PDS 
********************************************************
cd "$output"
clear
use PD_HKG_baseline_result_output
append using PD_CHN_baseline_result_output
replace Industry="Diversified" if Bloomberg_ID=="7935807"
drop if Industry=="Diversified" | Industry=="Financial"
drop if mainland_borrower==0 & type==0
drop if PD==. | assets==.
bys type date: egen total_assets_type=sum(assets)
gen assets_weight_type=assets/total_assets_type
bys type date Industry: egen total_assets_industry=sum(assets)
gen assets_weight_industry=assets/total_assets_industry
bys mainland_borrower date: egen total_assets_mainland=sum(assets)
bys mainland_borrower date Industry: egen industry_assets_mainland=sum(assets)
gen assets_weight_mainland=assets/total_assets_mainland
gen industry_assets_weight_mainland=assets/industry_assets_mainland
gen weight_PD=PD*assets_weight_type
gen weight_PD_industry=PD*assets_weight_industry
gen weight_PD_mainland=PD*assets_weight_mainland
gen weight_PD_mainland_industry=PD*industry_assets_weight_mainland


preserve
collapse(sum) weight_PD, by(type date)
drop if type==0
tostring type, replace
replace type="type"+type
reshape wide weight_PD, i(date) j(type) string
tsset date
tsline weight_PDtype1 weight_PDtype2
graph save "$graphs\Baseline_weightPD_bytype", replace
export excel using "$charts\BuDA_Charts", sheet("Baseline_weight_bytype") sheetmodify firstrow(variables)
save baseline_weight_PD, replace
restore

preserve
drop if type==0
drop if assets==.
collapse(sum) weight_PD_industry, by(type Industry date)
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
tostring type, replace
replace type="type"+type
rename weight_PD_industry PD
reshape wide PD, i(date type) j(I_) string
rename PD* *
sort type date
export excel using "$charts\BuDA_Charts", sheet("Baseline_weight_bytype_byind") sheetmodify firstrow(variables)
save baseline_weight_PD_industry, replace
restore

preserve
drop if mainland_borrower==0
collapse(sum) weight_PD_mainland, by(date)
tsset date
tsline weight_PD_mainland
graph save "$graphs\baseline_weightPD_MAINLAND", replace
export excel using "$charts\BuDA_Charts", sheet("baseline_weight_MAIN") sheetmodify firstrow(variables)
save baseline_weight_PD_industry_MAINLAND, replace
restore

preserve
drop if mainland_borrower==0
collapse(sum) weight_PD_mainland_industry, by(date Industry)
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
rename weight_PD_mainland_industry PD
reshape wide PD, i(date) j(I_) string
export excel using "$charts\BuDA_Charts", sheet("baseline_weight_MAIN_byind") sheetmodify firstrow(variables)
save baseline_weight_PD_industry_MAINLAND_byindustry, replace
restore
*/

********************************************************************************
/// 						CALCULATIONS: ADVERSE
********************************************************************************

cd "$output"
clear
use PD_HKG_adverse_result_output
append using PD_CHN_adverse_result_output
replace Industry="Diversified" if Bloomberg_ID=="7935807"
drop if Industry=="Diversified" | Industry=="Financial"
drop if mainland_borrower==0 & type==0


cd "$results"
preserve
drop if type==0
drop if Industry=="Diversified" | Industry=="Financial"
collapse(median) PD, by(type date)
tostring type, replace
replace type="type"+type
reshape wide PD, i(date) j(type) string
tsset date
tsline PDtype1 PDtype2
export excel using "$charts\BuDA_Charts", sheet("Adverse_type") sheetmodify firstrow(variables)
graph save "$graphs\Adverse_bytype", replace
save adverse_PD, replace
restore

cd "$results"
preserve
drop if type==0
drop if Industry=="Diversified" | Industry=="Financial"
collapse(median) PD, by(date)
export excel using "$charts\BuDA_Charts", sheet("adverse_notype") sheetmodify firstrow(variables)
save adverse_PD_notype, replace
restore

preserve
drop if type==0
drop if Industry=="Diversified" | Industry=="Financial"
collapse(median) PD, by(type Industry date)
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
tostring type, replace
replace type="type"+type
reshape wide PD, i(date type) j(I_) string
rename PD* *
sort type date
export excel using "$charts\BuDA_Charts", sheet("Adverse_industry") sheetmodify firstrow(variables)
*graph save "$graphs\Adverse_bytype_byindustry", replace
save adverse_PD_industry, replace
restore

preserve
drop if mainland_borrower==0
collapse(median) PD, by(date)
tsset date
tsline PD
export excel using "$charts\BuDA_Charts", sheet("Adverse_mainland") sheetmodify firstrow(variables)
graph save "$graphs\Adverse_MAINLAND", replace
save Adverse_PD_mainland, replace
restore

preserve
drop if mainland_borrower==0
collapse(median) PD, by(date Industry)
egen group=group(Industry)
xtset group date
tsline PD, by(Industry)
drop group
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
reshape wide PD, i(date) j(I_) string
ren PD* *
export excel using "$charts\BuDA_Charts", sheet("Adverse_mainland_industry") sheetmodify firstrow(variables)
graph save "$graphs\Adverse_byindustry_MAINLAND", replace
save Adverse_PD_industry_mainland, replace
restore

********************************************************
* 					WEIGHTED PDS
********************************************************
cd "$output"
clear
use PD_HKG_adverse_result_output
append using PD_CHN_adverse_result_output
replace Industry="Diversified" if Bloomberg_ID=="7935807"
drop if Industry=="Diversified" | Industry=="Financial"
drop if mainland_borrower==0 & type==0
drop if PD==. | assets==.
bys type date: egen total_assets_type=sum(assets)
gen assets_weight_type=assets/total_assets_type
bys type date Industry: egen total_assets_industry=sum(assets)
gen assets_weight_industry=assets/total_assets_industry
bys mainland_borrower date: egen total_assets_mainland=sum(assets)
bys mainland_borrower date Industry: egen industry_assets_mainland=sum(assets)
gen assets_weight_mainland=assets/total_assets_mainland
gen assets_weight_mainland_industry=assets/industry_assets_mainland
gen weight_PD=PD*assets_weight_type
gen weight_PD_industry=PD*assets_weight_industry
gen weight_PD_mainland=PD*assets_weight_mainland
gen weight_PD_mainland_industry=PD*assets_weight_mainland_industry

preserve
drop if type==0
collapse(sum) weight_PD, by(type date)
tostring type, replace
replace type="type"+type
reshape wide weight_PD, i(date) j(type) string
tsset date
tsline weight_PDtype1 weight_PDtype2
graph save "$graphs\Adverse_weightPD_bytype", replace
export excel using "$charts\BuDA_Charts", sheet("ADV_weight_bytype") sheetmodify firstrow(variables)
save adverse_weight_PD, replace
restore

preserve
drop if type==0
collapse(sum) weight_PD_industry, by(type Industry date)
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
tostring type, replace
replace type="type"+type
rename weight_PD_industry PD
reshape wide PD, i(date type) j(I_) string
sort type date
export excel using "$charts\BuDA_Charts", sheet("ADV_weight_bytype_ind") sheetmodify firstrow(variables)
save adverse_weight_PD_industry, replace
restore

preserve
drop if mainland_borrower==0
collapse(sum) weight_PD_mainland, by(date)
tsset date
tsline weight_PD_mainland
graph save "$graphs\Adverse_weightPD_MAINLAND", replace
export excel using "$charts\BuDA_Charts", sheet("ADV_weight_MAIN") sheetmodify firstrow(variables)
save adverse_weight_PD_industry_MAINLAND, replace
restore

preserve
drop if mainland_borrower==0
collapse(sum) weight_PD_mainland_industry, by(date Industry)
replace Industry=subinstr(Industry," ","",.)
rename Industry I_
rename weight_PD_mainland_industry PD
reshape wide PD, i(date) j(I_) string
export excel using "$charts\BuDA_Charts", sheet("ADV_weight_MAIN_ind") sheetmodify firstrow(variables)
save adverse_weight_PD_industry_MAINLAND_byindustry, replace
restore

