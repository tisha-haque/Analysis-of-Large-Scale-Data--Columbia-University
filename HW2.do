**Stata Assignment #2**
**Tisha Haque tnh2115**
**Pallavi Krishnamurthy pk2646 **

/// Load the NHIS data into Stata:
/// Note: you need to set the Stata working directory to the path where the data file is located

set more off
Clear
quietly infix
int year 1-4 ///
long serial 5-10 ///
int strata 11-14 ///
int psu 15-17 ///
str nhishid 18-31 ///
long hhweight 32-37
byte pernum 38-39 ///
str nhisid 40-55 ///
str hhx 56-61 ///
str fmx 62-63 /// 
str px 64-65 ///
double perweight 66-77 ///
long sampweight 78-86 ///
byte astatflg 93-93 ///
byte cstatflg 94-94 ///
byte age 95-96 ///
byte sex 97-97 ///
byte health 98-98 ///
byteaddes 99-99 ///
using '"nhis_00003.dat"'

format perweight %12.0f
format sampweight %9.0f

label var year '"Survey Year"'
label var serial '"Sequential Serial Number, Household Record"'
label var strata '"Stratum for variance estimation"'
label var psu '"Primary sampling unit (PSU) for variance estimation"'
label var nhishid '"NHIS Unique identifier, household"'
label var hhweight '"Household weight, final annual"'
label var pernum '"Person number within family (from reformatting)"'
label var nhispid '"NHIS unique identifier, person"'
label var hhx '"Household number (from NHIS)"'
label var fmx '"Family number (from NHIS)"'
label var px '"Person number of respondent (from NHIS)"'
label var perweight '"Final basical annual weight"'
label var sampweight '"Sample Person Weight"'
label var fweight '"Final annual family weight"'
label var astaflg '"Sample adult flag"'
label var cstaflg '"Sample child flag"'
label var age '"Age"'
label var sex '"Sex"'
label var health '"Health Status"'
label var addev '"Ever told had ADHD/ADD"'

Label define astaflg_lbl 0 '"NIU"'
Label define astaflg_lbl 1 '"Sample adult, has record"', add
Label define astaflg_lbl 2 '"Sample adult, no record"', add
Label define astaflg_lbl 3 '"Not selected as sample adult"', add
Label define astaflg_lbl 4 '"No one selected as sample adult"', add
Label define astaflg_lbl 5 '"Armed forces member"', add
Label define astaflg_lbl 6 '"AF member, selected as sample adult"'
label values astaflg astaflg_lbl 


label define cstaflg_lbl 0 '"NIU"'
label define cstaflg_lbl 1 '"Sample child, has record"', add
label define cstaflg_lbl 2 '"Sample child, no record"', add
label define cstaflg_lbl 3 '"Not selected as sample child"', add
label define cstaflg_lbl 4 '"No one selected as sample child"', add
label define cstaflg_lbl 5 '"Emancipated minor"', add
label value vstaflg cstaflg_lbl


Label define sex_lbl 1 '"Male"'
label define sex_lbl 2 '"Female"', add
label valyes sex sex_lbl

label define health_lbl 0 '"NIU"'
label define health_lbl 1 '"Excellent"', add
label define health_lbl 2 '"Very Good"', add
label define health_lbl 3 '"Good"', add
label define health_lbl 4 '"Fair"', add
label define health_lbl 5 '"Poor"', add
label define health_lbl 6 '"Unknown-refused"', add
label define health_lbl 7 '"Unknown-not ascetained"', add
label values addev addev_lbl

//Before beginning analyses, we must clean up our data. All unkowns, refusals, and NIU's will be codded as missing values

replace astaflg = . if astaflg ==0
replace cstaflg = . if cstaglf ==0
replace health = . if health >=6
replace health = . if health == 0

// Generate a dummy variable for sex
gen male= .
replace male= 1 if sex == 1
replace male= 0 of sex == 2

//Generate a new variable for whether a person has ADD/ADHD. (DSM definition changed in 2002.)
gen ADHD = .
replace ADHD = . if addev == 0
replace ADHD = . if addev >= 6
replace ADHD= 0 if addev == 1
replace ADHD = 1 if addev == 2

//Question 1

graph bar (count) ADHD of ADHD ==1, over (year)



//Question 2
// Regress ADHD against a linar time trend

reg ADHD year

//This trend is statistically significant when using a linear time trend

//Regress ADHD using dummy variable for each year

reg ADHD i.year

//The trend is statistically significant when using dummy variables for each year for all years except 1998 and 1999

///Question 3

reg ADHD year age male
/// note: we recorded our "sex" variable as "male" to make our output easier to interpret

///Question 4 
///First generate the binary dummy variable for health status

gen highhealth = .
replace highhealth =1 if health ==1
replace highhealth =1 if health ==2
replace highhealth =0 if health ==3
replace highhealth =0 if health ==4
replace highhealth =0 if health ==5

///Run the regression

reg ADHD year age male highhealth


///Question 5

///Generate the male-linear time trend interaction term

genm maleyear = male*year

///Run the regression

reg ADHD year age male highhealth maleyear

///Alternatively, we get the same result by using the # to create an interaction term and using "c." to indicate year is a continuous variable. We get the same results as the previous regression.

reg ADHD year age male highhealth male#c.year

///Question 6

reg ADHD 1.year age male highehalth male#1.years

///Question 7

///Repeating #1

graph bar(count) ADHD if ADHD ==1 [pw= samweight], over(year)

///Repeating #2
///Linear time trend

reg ADHD year [pw= sampweight]

/// Dummy variables for years

reg ADHD i.year

///Repeating #3

reg ADHD year age male [pw = sampweight]
/
//Repeating #4

reg ADHD year age male highhealth [pw = sampweight]





























