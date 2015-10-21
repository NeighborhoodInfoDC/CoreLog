/**************************************************************************
 Program:  Label and Prep Corelogic.sas
 Library:  {library}
 Project:  NeighborhoodInfo DC
 Author:   
 Created:  
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description: 

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

libname raw "L:\Libraries\CoreLog\Raw";

** Define libraries **;
%DCData_lib( CoreLog )

%let geog=natl cbsa county zip;
%let data_update=201401;
%read_corelogic_update(filedate=201401);

%macro read_corelogic_update(filedate=,finalize=N);

%do i=1 %to 4;
%let geo=%scan(&geog., &i.," ");

data test_&geo. (drop= 
					%if &geo.=zip %then %do; zip_code state_code fips_code %end;
					%if &geo.=county %then %do; fips_code %end;
					%if &geo.=cbsa %then %do; cbsa_code %end;
					%if &geo.=natl %then %do; state_code %end;
				 ); 

	set raw.&geo._&filedate.;

active_loan_count=LOAN_COUNT - REO; 
seriousdelinq=DELINQ_90PL_DAYS-REO;
delinq_90PL_only=DELINQ_90PL_DAYS- (foreclosures + reo);
ne_denom=ne_loans/ne_share;
agg_reo_sale=REO_SALE_MEAN*REO_SALE_COUNT; 
agg_resale_sale=RESALE_SALE_MEAN*RESALE_COUNT;
agg_total_sale=TOTAL_SALE_MEAN*TOTAL_SALE_COUNT; 
agg_newconstr_sale=NEW_CONSTR_MEAN*NEW_CONSTR_COUNT;
agg_short_sale=SHORT_SALE_MEAN*SHORT_SALE_COUNT;
agg_other_sale=OTHER_SALE_MEAN*OTHER_SALE_COUNT;

label agg_reo_sale="Aggregate REO sales prices"
		agg_resale_sale="Aggregate resale prices"
		agg_total_sale="Aggregate total sales prices"
		agg_newconstr_sale="Aggregate new contstruction sales prices"
		agg_short_sale="Aggregate short sales prices"
		agg_other_sale="Aggregate other non-arms length sales prices"
		seriousdelinq="Number of first-lien mortgages delinquent by 90 days or more or in foreclosure"
		active_loan_count="Number of outstanding first-lien mortgages (REO removed)"
		YYYYMM="Date"
		data_period="CoreLogic assigned period date"
		COMPL_FCLS ="Number of completed foreclosures"
		loan_count="Number of outstanding first-lien mortgages" /*85% coverage*/
		active_loan_count="Number of outstanding first-lien mortgages (REO removed)"
		delinq_90PL_only="Number of first-lient mortgages delinquent by 90 days or more"
		DELINQ_90PL_DAYS="Number of first-lien mortgages delinquent by 90 days or more (includes FC & REO)"
		FORECLOSURES="Number of first-lien mortgages in the foreclosure process"
		PRE_FC_FILINGS="Number of first-lien mortgages where public notice of default was filed"
		REO="Number of real-estate owned loans (lender took possession after foreclosure)"
		NE_LOANS="Number of properties with a mortgage in negative equity"
		ne_denom="Number of properties with a mortgage"
		TOTAL_SALE_COUNT="Number of home-sale transactions during the month" 
										/*Coverage 90% -Bing? Adjustments?
											all property types? SF,Condo? COOP? 1-4 units?*/
		RES_HOUSE_STK="Number of units, includes single family attached, detached, duplexes, triplexes, and condos." 
										/*85% coverage  - Use this # or other adjustment?*/

		REO_SALE_COUNT="Number of bank-owned properties sold to an unaffiliated third party"
		SHORT_SALE_COUNT="Number of short sales"
		OTHER_SALE_COUNT="Number of sales that are other non-arms length transactions (excludes REOs, short sales, etc.)"
		NEW_CONSTR_COUNT="Number of sales of newly constructed residential housing units" 
		RESALE_COUNT="Number of arms-length sales that were previously constructed homes"
		EQUITY_PCT="Mean percent of equity in a property" 
		
		NEW_CONSTR_MEAN="Mean sales price for new construction sales"
		NEW_CONSTR_MED="Median sales price for new construction sales"
		NE_SHARE="Percentage of properties in negative equity (denom is number of properties with a mortgage)"
		OTHER_SALE_MEAN="Mean sales price for other non-arms length transactions"
		OTHER_SALE_MED="Median sales price for other non-arms length transactions"
		PCT_NONOWN_PURC="Percent of purchase mortgage originations attributed to non-owner-occupied properties" 
		PCT_NONOWN_REFI="Percent of refinan ce mortgage originations attributed to non-owner-occupied properties" 
		PCT_NONOWN_TOT="Percent of all mortgage originations attributed to non-owner-occupied properties" 
		REO_SALE_MEAN="Mean sales price for bank-owned properties"
		REO_SALE_MED="Median sales price for bank-owned properties"
		RESALE_SALE_MEAN="Mean sales price for sales of existing homes"
		RESALE_SALE_MED="Median sales price for sales of existing homes"
		SHORT_SALE_MEAN="Mean sales price for homes sold via short sale"
		SHORT_SALE_MED="Median sales price for homes sold via short sale"
		TOTAL_MED_LTV="Median loan-to-value ratio (mortgage debt to sales price)"
		TOTAL_SALE_MEAN="Mean sales price of all home sale transactions"
		TOTAL_SALE_MED="Median sales price of all home sale transactions"
;
%if &geo=natl %then %do;
length state_fips $2.;
state_fips=state_code;
label state_fips="State FIPS Code (SS)"
	  state_name="State Name";
	  
state_fips="99";
%end; 

%if &geo=cbsa %then %do;
length metro13 $5.;
metro13=cbsa_code; 

label metro13="Core Based Statistical Area Code (2013 Definitions)"
	  cbsa_name="Core Based Statistical Area Name (2013 Definitions)";
%end; 


%if &geo=county %then %do;
length ucounty $5.;
ucounty=FIPS_CODE;
	label  	COUNTY_NAME="Name of County"
			ucounty="State and County FIPS (SSCCC)"
;
%end;  


%if &geo=zip %then %do;
length ucounty zip $5. state_fips $2.;
zip=zip_code; 
ucounty=FIPS_CODE;
state_fips=state_code; 

	label  	COUNTY_NAME="Name of County"
			ucounty="State and County FIPS (SSCCC)"
			state_name="State Name"
			zip="ZIP Code"
			state_fips="State FIPS code (SS)"
;
%end;  

/*metadata*/
run;
%end;

%mend;


 

