 
clear
import sasxport5 CDBRFs10.XPT 
des
tab rmvteth3

**Question 1

gen teethloss =.
 replace teethloss =0 if rmvteth3==8
replace teethloss =1 if rmvteth3==1
 replace teethloss =2 if rmvteth3==2
  replace teethloss =3 if rmvteth3==3
   replace teethloss =4 if rmvteth3==7 | rmvteth3==9
   
   
   label var teethloss "Number of Permanent Teeth Removed"
   label define teethlosslabels 0 "None" 1 "1 to 5" 2 "6 or more" 3 "All" 4 "Don't know/refused"
   label values teethloss teethlosslabels 
   
   tab teethloss
   
   **Question 2
    gen teethlossbinary =.
	replace teethlossbinary =0 if rmvteth3==8
	replace teethlossbinary =1 if rmvteth3==1 | rmvteth3==2 | rmvteth3==3
	tab teethlossbinary
	
	
	tab age
	
	gen age_fixed = age
	replace age_fixed =. if age ==7 | age==9
	histogram age_fixed if teethlossbinary ==1, d freq
	
	tab age_fixed if teethlossbinary ==1
	
	   **Question 3
	   
	  *Fix age variable 
	   tab age_fixed
	   
	   tab income2 
	   gen income_fixed = income2
	   replace income_fixed =. if income2 ==77 | income2 ==99
	   
	   *Fix race variable
	   tab race2
	   
	   gen race_fixed = race2
	   replace race_fixed=. if race2==9
	   tab age_fixed
	   
	   
	   *Fix education variable
	   tab educa
	   gen educa_fixed = educa
	   replace educa_fixed=. if educa==9
	   
	   tab educa_fixed
	   
	   *Fix our sex variable- did not need to change anything
	   tab sex
	   
	   
	   
	   *Fix marital status variable
	   
	   tab marital
	   gen marital_fixed = marital
	   replace marital_fixed=. if marital ==9
	   
	   tab marital_fixed
	   
	   ** running a linear regression
	   
	   reg teethlossbinary age_fixed i.income_fixed i.race_fixed i.educa_fixed i.sex i. marital_fixed
	   
	   **this many more percentage points then this category in tooth loss
	   ** females are less likely then males to have teeth loss, male has the lower code for sex
	   **females have 3.4% percentage points less of lossing teeth  than males
	   
	   
	   *Question 4
* convert census2010.csv into a stata .dta file
import delimited census2010
rename state _state
rename county _ctycode
duplicates drop

* save at a .dta file
	   
*Import the CBP data file
	   

import delimited cbp10co.txt
keep if naics == "6212//"
keep fipstate fipscty est

ren fipstate _state
ren fipscty ctycode

*merge CBP data with census 2010.csv

merge 1:1 _state ctycode using census2010
gen dentpercapita = est/pop
	   
*Merge 	   
	   
	   
	   
	   
	   
	   
