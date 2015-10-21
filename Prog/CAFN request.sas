%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Corelog ) 

*Line Chart – Nation vs. Metro Area Trends (Monthly 2000-2013) in Delinquency Rate (90+ days) and Foreclosure Rate (Share in foreclosure process);
data natl (rename=(state_name=jurisdiction));
	set corelog.mkttrends_natl;

pct_foreclosures=FORECLOSURES/active_loan_count*100;
pct_delinq_90PL_only=delinq_90PL_only/active_loan_count*100;
 	
keep state_name yyyymm pct_foreclosures FORECLOSURES pct_delinq_90PL_only delinq_90PL_only active_loan_count ;

run;
data cbsa1;
	set corelog.mkttrends_cbsa;

length cbsa $5.;
cbsa="47900";

run;

*summarize to collapse Silver Spring-Bethesda Metro Division and DC Metro Division;
proc sort data=cbsa1;
by cbsa YYYYMM;
proc summary data=cbsa1;
by cbsa YYYYMM;
id data_period;
var active_loan_count seriousdelinq delinq_90PL_only DELINQ_90PL_DAYS FORECLOSURES REO LOAN_COUNT PRE_FC_FILINGS COMPL_FCLS NEW_CONSTR_COUNT RESALE_COUNT 
	REO_SALE_COUNT SHORT_SALE_COUNT OTHER_SALE_COUNT TOTAL_SALE_COUNT NE_LOANS RES_HOUSE_STK ne_denom agg_reo_sale 
	agg_resale_sale agg_total_sale agg_newconstr_sale agg_short_sale agg_other_sale;
output out=cbsa_sum sum=;

run;

*create percentages  *original variables are in CAPS and UI created vars in lowercase**;
data cbsa_sum_pct;
	set cbsa_sum;

pct_reo=REO/LOAN_COUNT*100;

*create demoninator for active loan count that excludes REO loans (coverage of REO is estimated at 50% assume still reporting REO varies by servicer); 
active_loan_count=LOAN_COUNT - REO; 

*variables with active loan-count as denominator;
seriousdelinq=DELINQ_90PL_DAYS-REO;
pct_seriousdelinq=(DELINQ_90PL_DAYS-REO)/active_loan_count*100;
pct_foreclosures=FORECLOSURES/active_loan_count*100;
pct_pre_fc_filings=PRE_FC_FILINGS/active_loan_count*100;
 	
*Create delinquency var (without REO & FC);
delinq_90PL_only=DELINQ_90PL_DAYS- (foreclosures + reo); *Does this also include preforeclosure filings?;
pct_delinq_90PL_only=delinq_90PL_only/active_loan_count*100;

*create new ne_share; 
ne_share=NE_LOANS/ne_denom*100;


label 
pct_seriousdelinq="Percent of first-lien mortgages delinquent by 90 days or more or in foreclosure"
pct_foreclosures="Percent of first-lien mortgages in the foreclosure process"
pct_pre_fc_filings="Percent of first-lien mortgages where public notice of default was filed"
pct_reo="Percent of first-lien mortgages that are real-estate owned (lender took possession after foreclosure)"
ne_share="Percent of properties in negative equity"
;

*variables with total_sale_count as denominator;

pct_reo_sale=REO_SALE_COUNT/TOTAL_SALE_COUNT*100; 
pct_short_sale=SHORT_SALE_COUNT/TOTAL_SALE_COUNT*100;
pct_other_sale=OTHER_SALE_COUNT/TOTAL_SALE_COUNT*100; 
pct_newconstr_sale=NEW_CONSTR_COUNT/TOTAL_SALE_COUNT*100; 
pct_resale_sale=RESALE_COUNT/TOTAL_SALE_COUNT*100;

TOTAL_SALE_MEAN=agg_total_sale/TOTAL_SALE_COUNT;
NEW_CONSTR_MEAN=agg_newconstr_sale/NEW_CONSTR_COUNT; 
OTHER_SALE_MEAN=agg_other_sale/OTHER_SALE_COUNT;
REO_SALE_MEAN=agg_reo_sale/REO_SALE_COUNT;
RESALE_SALE_MEAN=agg_resale_sale/RESALE_COUNT; 
SHORT_SALE_MEAN=agg_short_sale/SHORT_SALE_COUNT;

label 	pct_reo_sale="Percent of sales that were bank-owned and sold to an unaffiliated third party"
		pct_short_sale="Percent of sales that were short sales"
		pct_other_sale="Percent of sales that were other non-arms length transactions"
		pct_newconstr_sale="Percent of sales that were newly constructed residential housing units"
		pct_resale_sale="Percent of sales that were arm-length and involved previously constructed homes"
		NEW_CONSTR_MEAN="Mean sales price for new construction sales"
		OTHER_SALE_MEAN="Mean sales price for other non-arms length transactions"
		REO_SALE_MEAN="Mean sales price for bank-owned properties"
		RESALE_SALE_MEAN="Mean sales price for sales of existing homes"
		SHORT_SALE_MEAN="Mean sales price for homes sold via short sale"
		TOTAL_SALE_MEAN="Mean sales price for all homes sold"
;
run;																		



data county1 ;
	set corelog.mkttrends_county  ;

pct_reo=REO/LOAN_COUNT*100;
*variables with active loan-count as denominator;
pct_seriousdelinq=(DELINQ_90PL_DAYS-REO)/active_loan_count*100;
pct_foreclosures=FORECLOSURES/active_loan_count*100;
pct_pre_fc_filings=PRE_FC_FILINGS/active_loan_count*100;
 	

*Create delinquency var (without REO & FC);
pct_delinq_90PL_only=delinq_90PL_only/active_loan_count*100;

label 
		seriousdelinq="Number of first-lien mortgages delinquent by 90 days or more or in foreclosure"
		pct_seriousdelinq="Percent of first-lien mortgages delinquent by 90 days or more or in foreclosure"
		pct_foreclosures="Percent of first-lien mortgages in the foreclosure process"
		pct_pre_fc_filings="Percent of first-lien mortgages where public notice of default was filed"
		pct_reo="Percent of first-lien mortgages that are real-estate owned (lender took possession after foreclosure)"
;

*variables with total_sale_count as denominator;

pct_reo_sale=REO_SALE_COUNT/TOTAL_SALE_COUNT*100; 
pct_short_sale=SHORT_SALE_COUNT/TOTAL_SALE_COUNT*100;
pct_other_sale=OTHER_SALE_COUNT/TOTAL_SALE_COUNT*100; 
pct_newconstr_sale=NEW_CONSTR_COUNT/TOTAL_SALE_COUNT*100; 
pct_resale_sale=RESALE_COUNT/TOTAL_SALE_COUNT*100;

label 	pct_reo_sale="Percent of sales that were bank-owned and sold to an unaffiliated third party"
		pct_short_sale="Percent of sales that were short sales"
		pct_other_sale="Percent of sales that were other non-arms length transactions"
		pct_newconstr_sale="Percent of sales that were newly constructed residential housing units"
		pct_resale_sale="Percent of sales that were arm-length and involved previously constructed homes"
;

*flag for VA counties to use in CAFN analysis;

va_counties=0;
if ucounty in ("51013" "51043"  "51059" "51061" "51107" "51153" "51177" "51179" "51187" "51510" "51600" "51610" "51630" "51683" "51685" "51047" "51157") then va_counties=1;

md_counties=0;
if ucounty in ("24009" "24017" "24021" "24031" "24033") then md_counties=1; 

metro_2003=0;
if ucounty in ("51013" "51043" "51059" "51061" "51107" "51153" "51177" "51179" "51187" "51510" "51600" "51610" "51630" "51683" "51685" 
			   "24009" "24017" "24021" "24031" "24033" "54037" "11001" )
then metro_2003=1; 

cog_counties=0;
cog_md_counties=0;
cog_va_counties=0;

if ucounty in ("24031" "24033") then cog_md_counties=1;
if ucounty in ("51013"  "51059" "51107" "51153" "51510" "51600" "51610" "51683" "51685") then cog_va_counties=1;

if cog_md_counties=1 then cog_counties=1;
if cog_va_counties=1 then cog_counties=1;
if ucounty="11001" then cog_counties=1; 


agg_reo_sale=REO_SALE_MEAN*REO_SALE_COUNT; 
agg_resale_sale=RESALE_SALE_MEAN*RESALE_COUNT;
agg_total_sale=TOTAL_SALE_MEAN*TOTAL_SALE_COUNT; 
agg_newconstr_sale=NEW_CONSTR_MEAN*NEW_CONSTR_COUNT;
agg_short_sale=SHORT_SALE_MEAN*SHORT_SALE_COUNT;
agg_other_sale=OTHER_SALE_MEAN*OTHER_SALE_COUNT;

label 	agg_reo_sale="Aggregate REO sales prices"
		agg_resale_sale="Aggregate resale prices"
		agg_total_sale="Aggregate total sales prices"
		agg_newconstr_sale="Aggregate new contstruction sales prices"
		agg_short_sale="Aggregate short sales prices"
		agg_other_sale="Aggregate other non-arms length sales prices";

ui_order=.;
if ucounty="11001" then ui_order=2;
if ucounty="24031" then ui_order=4;
if ucounty="24033" then ui_order=5;
if ucounty="51510" then ui_order=7;
if ucounty="51013" then ui_order=8;
if ucounty="51059" then ui_order=9;
if ucounty="51600" then ui_order=10;
if ucounty="51610" then ui_order=11;
if ucounty="51107" then ui_order=12;
if ucounty="51153" then ui_order=13;
if ucounty="51683" then ui_order=14;
if ucounty="51685" then ui_order=15;

market_sale_count=NEW_CONSTR_COUNT+RESALE_COUNT;  
pct_market=market_sale_count/TOTAL_SALE_COUNT*100;

Market_sale_mean=(agg_newconstr_sale+agg_resale_sale)/(market_sale_count);
run;		

proc contents data=county1;
run;
proc freq data=county1;
tables ucounty;
run;


*summarize for va cog counties;
proc sort data=county1;
by  YYYYMM;
proc summary data=county1;
where cog_va_counties=1;
by  YYYYMM;
id  data_period;
var active_loan_count seriousdelinq delinq_90PL_only DELINQ_90PL_DAYS FORECLOSURES REO LOAN_COUNT PRE_FC_FILINGS COMPL_FCLS NEW_CONSTR_COUNT RESALE_COUNT 
	REO_SALE_COUNT SHORT_SALE_COUNT OTHER_SALE_COUNT TOTAL_SALE_COUNT NE_LOANS RES_HOUSE_STK ne_denom agg_reo_sale 
	agg_resale_sale agg_total_sale agg_newconstr_sale agg_short_sale agg_other_sale;
output out=va_cog_sum sum=; 
run;

*summarize for md cog counties;
proc sort data=county1;
by  YYYYMM;
proc summary data=county1;
where cog_md_counties=1;
by  YYYYMM;
id  data_period;
var active_loan_count seriousdelinq delinq_90PL_only DELINQ_90PL_DAYS FORECLOSURES REO LOAN_COUNT PRE_FC_FILINGS COMPL_FCLS NEW_CONSTR_COUNT RESALE_COUNT 
	REO_SALE_COUNT SHORT_SALE_COUNT OTHER_SALE_COUNT TOTAL_SALE_COUNT NE_LOANS RES_HOUSE_STK ne_denom agg_reo_sale 
	agg_resale_sale agg_total_sale agg_newconstr_sale agg_short_sale agg_other_sale;
output out=md_cog_sum sum=; 
run;

*summarize for 2003 dc metro;
proc sort data=county1;
by  YYYYMM;
proc summary data=county1;
where metro_2003=1;
by YYYYMM;
id data_period;
var active_loan_count seriousdelinq delinq_90PL_only DELINQ_90PL_DAYS FORECLOSURES REO LOAN_COUNT PRE_FC_FILINGS COMPL_FCLS NEW_CONSTR_COUNT RESALE_COUNT 
	REO_SALE_COUNT SHORT_SALE_COUNT OTHER_SALE_COUNT TOTAL_SALE_COUNT NE_LOANS RES_HOUSE_STK ne_denom agg_reo_sale 
	agg_resale_sale agg_total_sale agg_newconstr_sale agg_short_sale agg_other_sale;
output out=metro2003_sum sum=; 
run;

*summarize for all cog counties;
proc sort data=county1;
by  YYYYMM;
proc summary data=county1;
where cog_counties=1;
by YYYYMM;
id data_period;
var active_loan_count seriousdelinq delinq_90PL_only DELINQ_90PL_DAYS FORECLOSURES REO LOAN_COUNT PRE_FC_FILINGS COMPL_FCLS NEW_CONSTR_COUNT RESALE_COUNT 
	REO_SALE_COUNT SHORT_SALE_COUNT OTHER_SALE_COUNT TOTAL_SALE_COUNT NE_LOANS RES_HOUSE_STK ne_denom agg_reo_sale 
	agg_resale_sale agg_total_sale agg_newconstr_sale agg_short_sale agg_other_sale;
output out=COG_sum sum=; 
run;

DATA va_cog_sum2;
	set va_cog_sum;

length jurisdiction $35. ucounty $5.;
ucounty="00005";
jurisdiction="Virginia Jurisdictions";
ui_order=6;

run; 

data md_cog_sum2; 
	set md_cog_sum;
ucounty="00004";
length jurisdiction $35. ucounty $5.;

jurisdiction="Maryland Jurisdictions";
ui_order=3;
run; 

data cog_sum2;
	set cog_sum;
length jurisdiction $35. ucounty $5.;
ucounty="00002";
jurisdiction="All COG Jurisdictions";
ui_order=1;
run;
data metro2003_sum2;
	set metro2003_sum;
length jurisdiction $35. ucounty $5.;
ucounty="00001";
jurisdiction="Washington, DC Metropolitan Area";
ui_order=0; 
run;

data combine_sum;
	set metro2003_sum2 cog_sum2 md_cog_sum2 va_cog_sum2; 

pct_reo=REO/LOAN_COUNT*100;

pct_seriousdelinq=(DELINQ_90PL_DAYS-REO)/active_loan_count*100;
pct_foreclosures=FORECLOSURES/active_loan_count*100;
pct_pre_fc_filings=PRE_FC_FILINGS/active_loan_count*100;
 	

*Create delinquency var (without REO & FC);
pct_delinq_90PL_only=delinq_90PL_only/active_loan_count*100;

*create new ne_share; 
ne_share=NE_LOANS/ne_denom*100;

*variables with total_sale_count as denominator;

pct_reo_sale=REO_SALE_COUNT/TOTAL_SALE_COUNT*100; 
pct_short_sale=SHORT_SALE_COUNT/TOTAL_SALE_COUNT*100;
pct_other_sale=OTHER_SALE_COUNT/TOTAL_SALE_COUNT*100; 
pct_newconstr_sale=NEW_CONSTR_COUNT/TOTAL_SALE_COUNT*100; 
pct_resale_sale=RESALE_COUNT/TOTAL_SALE_COUNT*100;

market_sale_count=NEW_CONSTR_COUNT+RESALE_COUNT;  
pct_market=market_sale_count/TOTAL_SALE_COUNT*100;

Market_sale_mean=(agg_newconstr_sale+agg_resale_sale)/(market_sale_count);

TOTAL_SALE_MEAN=agg_total_sale/TOTAL_SALE_COUNT;
NEW_CONSTR_MEAN=agg_newconstr_sale/NEW_CONSTR_COUNT; 
OTHER_SALE_MEAN=agg_other_sale/OTHER_SALE_COUNT;
REO_SALE_MEAN=agg_reo_sale/REO_SALE_COUNT;
RESALE_SALE_MEAN=agg_resale_sale/RESALE_COUNT; 
SHORT_SALE_MEAN=agg_short_sale/SHORT_SALE_COUNT;
run; 

*merge back on to counties;

data county2;

set county1 combine_sum;

if jurisdiction=" " and ucounty="11001" then jurisdiction="District of Columbia"; 
else if ucounty not in ("00001" "00002" "00003" "00004" "00005") then jurisdiction=" ";

if jurisdiction=" " then jurisdiction=county_name;
run; 

*metro2003 trend;
data metro2003_sum3;
	set metro2003_sum2;

pct_foreclosures=FORECLOSURES/active_loan_count*100;
pct_delinq_90PL_only=delinq_90PL_only/active_loan_count*100;
 	
keep jurisdiction yyyymm pct_foreclosures FORECLOSURES pct_delinq_90PL_only delinq_90PL_only active_loan_count ;
run;

proc export data=metro2003_sum3 
 OUTFILE= "K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\Metro2003trend.csv" 
            DBMS=csv REPLACE;
RUN;

proc export data=natl 
 OUTFILE= "K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\natltrend.csv" 
            DBMS=csv REPLACE;
RUN;
data dc_foreclosures;
	set county2;

where ucounty="11001";
keep jurisdiction ucounty yyyymm pct_foreclosures FORECLOSURES pct_delinq_90PL_only delinq_90PL_only active_loan_count;
run;
data pg_foreclosures;
set county2;
where ucounty="24033";
keep jurisdiction ucounty yyyymm pct_foreclosures FORECLOSURES pct_delinq_90PL_only delinq_90PL_only active_loan_count;
run;
proc export data=dc_foreclosures 
 OUTFILE= "K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\dc_foreclosures.csv" 
            DBMS=csv REPLACE;
RUN;
proc export data=pg_foreclosures 
 OUTFILE= "K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\pg_foreclosures.csv" 
            DBMS=csv REPLACE;
RUN;
*table 1; 
data county3; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);


*foreclosure rate only;
keep jurisdiction yyyymm pct_foreclosures ucounty county_name ;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;


run;
proc sort data=county3;
by jurisdiction;
proc transpose data=county3 out=table1 prefix=pct_foreclosures;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table1_pc (drop=YYYYMM);
merge table1 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction; 


*calculate pct. change;
pct_chg_2000_06=(pct_foreclosures200612-pct_foreclosures200012)/pct_foreclosures200012*100; 
pct_chg_2006_09=(pct_foreclosures200912-pct_foreclosures200612)/pct_foreclosures200612*100; 
pct_chg_2009_13=(pct_foreclosures201312-pct_foreclosures200912)/pct_foreclosures200912*100; 
pct_chg_2000_13=(pct_foreclosures201312-pct_foreclosures200012)/pct_foreclosures200012*100; 

run;
proc sort data=table1_pc;
by Ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]ForeClosure Rate!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table1_pc;
	put  pct_foreclosures200012 pct_foreclosures200612 pct_foreclosures200912 pct_foreclosures201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;

*table 2; 
data county4; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*90 day plus rate only;
keep jurisdiction yyyymm pct_delinq_90PL_only ucounty county_name;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;


run;
proc sort data=county4;
by jurisdiction;
proc transpose data=county4 out=table2 prefix=pct_delinq_90PL_only;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table2_pc (drop=YYYYMM);;
merge table2 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;

*calculate pct. change;
pct_chg_2000_06=(pct_delinq_90PL_only200612-pct_delinq_90PL_only200012)/pct_delinq_90PL_only200012*100; 
pct_chg_2006_09=(pct_delinq_90PL_only200912-pct_delinq_90PL_only200612)/pct_delinq_90PL_only200612*100; 
pct_chg_2009_13=(pct_delinq_90PL_only201312-pct_delinq_90PL_only200912)/pct_delinq_90PL_only200912*100; 
pct_chg_2000_13=(pct_delinq_90PL_only201312-pct_delinq_90PL_only200012)/pct_delinq_90PL_only200012*100; 

run;
proc sort data=table2_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]Delinquency!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table2_pc;
	put  pct_delinq_90PL_only200012 pct_delinq_90PL_only200612 pct_delinq_90PL_only200912 pct_delinq_90PL_only201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;


data county5 (where=(year in ("2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013")));

set county1 (where=(cog_counties=1)); 

length date_char $6. year $4.;
date_char=yyyymm;
year=substr(date_char,1,4);

run;
 
proc sort data=county5;
by ucounty;
proc summary data=county5;
by ucounty;
id county_name;
var COMPL_FCLS;
output out=county_fcls sum=;
run;

proc sort data=county5;
by ucounty year;
proc summary data=county5;
by ucounty year;
id county_name;
var COMPL_FCLS;
output out=county_fcls_year sum=;
run;

proc sort data=county_fcls_year;
by ucounty;
proc transpose data=county_fcls_year out=table3 prefix=compl_fcls;
id year;
by ucounty;
run;

data table3_r;
	set table3;

if _name_ in ("_TYPE_" "_FREQ_") then delete;

compl_fcls_2006_13=sum(compl_fcls2006, compl_fcls2007, compl_fcls2008, compl_fcls2009, compl_fcls2010, compl_fcls2011, compl_fcls2012, compl_fcls2013);

run;

filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]completed!R3C2:R19C11" ;

data _null_ ;
	file outexc lrecl=65000;
	set table3_r;
	put  ucounty compl_fcls2006 compl_fcls2007 compl_fcls2008 compl_fcls2009 compl_fcls2010 compl_fcls2011 compl_fcls2012 compl_fcls2013 compl_fcls_2006_13

	;
	run;



*table 4; 
data county6; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*sales volume;
keep jurisdiction yyyymm TOTAL_SALE_COUNT ucounty county_name;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;
run;
proc sort data=county6;
by jurisdiction;
proc transpose data=county6 out=table4 prefix=TOTAL_SALE_COUNT;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table4_pc (drop=YYYYMM);;
merge table4 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;

*calculate pct. change;
pct_chg_2000_06=(TOTAL_SALE_COUNT200612-TOTAL_SALE_COUNT200012)/TOTAL_SALE_COUNT200012*100; 
pct_chg_2006_09=(TOTAL_SALE_COUNT200912-TOTAL_SALE_COUNT200612)/TOTAL_SALE_COUNT200612*100; 
pct_chg_2009_13=(TOTAL_SALE_COUNT201312-TOTAL_SALE_COUNT200912)/TOTAL_SALE_COUNT200912*100; 
pct_chg_2000_13=(TOTAL_SALE_COUNT201312-TOTAL_SALE_COUNT200012)/TOTAL_SALE_COUNT200012*100; 

run;
proc sort data=table4_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]Sales Volume!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table4_pc;
	put  TOTAL_SALE_COUNT200012 TOTAL_SALE_COUNT200612 TOTAL_SALE_COUNT200912 TOTAL_SALE_COUNT201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;


	*table 5; 
data county7; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*median sales price;
keep jurisdiction yyyymm TOTAL_SALE_MEAN ucounty county_name; *UNADJUSTED FOR INFLATION;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;

run;
proc sort data=county7;
by jurisdiction;
proc transpose data=county7 out=table5 prefix=TOTAL_SALE_MEAN;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table5_pc (drop=YYYYMM);;
merge table5 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;
%dollar_convert_month(TOTAL_SALE_MEAN200012, TOTAL_SALE_MEAN200012r, 12, 2000, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
%dollar_convert_month(TOTAL_SALE_MEAN200612, TOTAL_SALE_MEAN200612r, 12, 2006, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
%dollar_convert_month(TOTAL_SALE_MEAN200912, TOTAL_SALE_MEAN200912r, 12, 2009, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );

*calculate pct. change;
pct_chg_2000_06=(TOTAL_SALE_MEAN200612r-TOTAL_SALE_MEAN200012r)/TOTAL_SALE_MEAN200012r*100; 
pct_chg_2006_09=(TOTAL_SALE_MEAN200912r-TOTAL_SALE_MEAN200612r)/TOTAL_SALE_MEAN200612r*100; 
pct_chg_2009_13=(TOTAL_SALE_MEAN201312-TOTAL_SALE_MEAN200912r)/TOTAL_SALE_MEAN200912r*100; 
pct_chg_2000_13=(TOTAL_SALE_MEAN201312-TOTAL_SALE_MEAN200012r)/TOTAL_SALE_MEAN200012r*100; 

run;
proc sort data=table5_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]Sales Price!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table5_pc;
	put  TOTAL_SALE_MEAN200012r TOTAL_SALE_MEAN200612r TOTAL_SALE_MEAN200912r TOTAL_SALE_MEAN201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;

	*table 6; 
data county8; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*negative equity share;
keep jurisdiction yyyymm ne_share ucounty county_name;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;
if ucounty not in ("00001" "00002"  "00004" "00005") then ne_share=ne_share*100;

run;
proc sort data=county8;
by jurisdiction;
proc transpose data=county8 out=table6 prefix=ne_share;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table6_pc (drop=YYYYMM);
merge table6 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;
*calculate pct. change;
pct_chg_2000_06=(NE_SHARE200612-NE_SHARE200012)/NE_SHARE200012*100; 
pct_chg_2006_09=(NE_SHARE200912-NE_SHARE200612)/NE_SHARE200612*100; 
pct_chg_2009_13=(NE_SHARE201312-NE_SHARE200912)/NE_SHARE200912*100; 
pct_chg_2000_13=(NE_SHARE201312-NE_SHARE200012)/NE_SHARE200012*100; 

run;
proc sort data=table6_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]Neg Equity!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table6_pc;
	put  NE_SHARE200012 NE_SHARE200612 NE_SHARE200912 NE_SHARE201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;
*pct_short_sale;

	data county9; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*negative equity share;
keep jurisdiction yyyymm pct_short_sale ucounty county_name;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;

run;
proc sort data=county9;
by jurisdiction;
proc transpose data=county9 out=table7 prefix=pct_short;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table7_pc (drop=YYYYMM);
merge table7 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;
*calculate pct. change;
pct_chg_2000_06=(pct_short200612-pct_short200012)/pct_short200012*100; 
pct_chg_2006_09=(pct_short200912-pct_short200612)/pct_short200612*100; 
pct_chg_2009_13=(pct_short201312-pct_short200912)/pct_short200912*100; 
pct_chg_2000_13=(pct_short201312-pct_short200012)/pct_short200012*100; 

run;
proc sort data=table7_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]ShortSale!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table7_pc;
	put  pct_short200012 pct_short200612 pct_short200912 pct_short201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;

*pct_reo_sale;
		data county10; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*negative equity share;
keep jurisdiction yyyymm pct_reo_sale ucounty county_name;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;

run;
proc sort data=county10;
by jurisdiction;
proc transpose data=county10 out=table8 prefix=pct_reo;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table8_pc (drop=YYYYMM);
merge table8 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;
*calculate pct. change;
pct_chg_2000_06=(pct_REO200612-pct_REO200012)/pct_REO200012*100; 
pct_chg_2006_09=(pct_REO200912-pct_REO200612)/pct_REO200612*100; 
pct_chg_2009_13=(pct_REO201312-pct_REO200912)/pct_REO200912*100; 
pct_chg_2000_13=(pct_REO201312-pct_REO200012)/pct_REO200012*100; 

run;
proc sort data=table8_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]REOSales!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table8_pc;
	put  pct_REO200012 pct_REO200612 pct_REO200912 pct_REO201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;

	*zip code data;
data zips1;
	set corelog.mkttrends_zip;


if yyyymm in (200012 200612 200912 201312);

	pct_foreclosures=FORECLOSURES/active_loan_count*100;
pct_delinq_90PL_only=delinq_90PL_only/active_loan_count*100;

if ucounty not in ("51013" "51043" "51059" "51061" "51107" "51153" "51177" "51179" "51187" "51510" "51600" "51610" "51630" "51683" "51685" 
			   "24009" "24017" "24021" "24031" "24033" "54037" "11001" ) then delete; 
if active_loan_count < 100 then delete; 

keep zip yyyymm ucounty county_name state_fips pct_foreclosures ;
run;

proc sort data=zips1;
by zip;
proc transpose data=zips1 out=zips_fc prefix=pct_fc;
id yyyymm;
by zip;
run;
data zips_fc_pc (drop=YYYYMM);
merge zips_fc (in=a) zips1 (where=(YYYYMM=201312)keep=zip YYYYMM ucounty county_name state_fips);
if a;
by zip;


*calculate pct. change;
pct_chg_2000_06=(pct_fc200612-pct_fc200012)/pct_fc200012*100; 
pct_chg_2006_09=(pct_fc200912-pct_fc200612)/pct_fc200612*100; 
pct_chg_2009_13=(pct_fc201312-pct_fc200912)/pct_fc200912*100; 
pct_chg_2000_13=(pct_fc201312-pct_fc200012)/pct_fc200012*100; 
run; 

proc export data=zips_fc_pc 
 OUTFILE= "K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\zips_fc_pc.csv" 
            DBMS=csv REPLACE;
RUN;
data zips2;
	set corelog.mkttrends_zip;


if yyyymm in (200012 200612 200912 201312);

	pct_foreclosures=FORECLOSURES/active_loan_count*100;
pct_delinq_90PL_only=delinq_90PL_only/active_loan_count*100;

if ucounty not in ("51013" "51043" "51059" "51061" "51107" "51153" "51177" "51179" "51187" "51510" "51600" "51610" "51630" "51683" "51685" 
			   "24009" "24017" "24021" "24031" "24033" "54037" "11001" ) then delete; 
if active_loan_count < 100 then delete; 

keep zip yyyymm ucounty county_name state_fips pct_delinq_90PL_only ;
run;

proc sort data=zips2;
by zip;
proc transpose data=zips2 out=zips_dq prefix=pct_dq;
id yyyymm;
by zip;
run;
data zips_dq_pc (drop=YYYYMM);
merge zips_dq (in=a) zips2 (where=(YYYYMM=201312)keep=zip YYYYMM ucounty county_name state_fips);
if a;
by zip;


*calculate pct. change;
pct_chg_2000_06=(pct_dq200612-pct_dq200012)/pct_dq200012*100; 
pct_chg_2006_09=(pct_dq200912-pct_dq200612)/pct_dq200612*100; 
pct_chg_2009_13=(pct_dq201312-pct_dq200912)/pct_dq200912*100; 
pct_chg_2000_13=(pct_dq201312-pct_dq200012)/pct_dq200012*100; 
run; 

proc export data=zips_dq_pc 
 OUTFILE= "K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\zips_dq_pc.csv" 
            DBMS=csv REPLACE;
RUN;

data zips3;
	set corelog.mkttrends_zip;


if yyyymm in (200012 200612 200912 201312);


if ucounty not in ("51013" "51043" "51059" "51061" "51107" "51153" "51177" "51179" "51187" "51510" "51600" "51610" "51630" "51683" "51685" 
			   "24009" "24017" "24021" "24031" "24033" "54037" "11001" ) then delete; 


keep zip yyyymm ucounty county_name state_fips ne_share ;
run;

proc sort data=zips3;
by zip;
proc transpose data=zips3 out=zips_ne prefix=ne_share;
id yyyymm;
by zip;
run;
data zips_ne_pc (drop=YYYYMM);
merge zips_ne (in=a) zips3 (where=(YYYYMM=201312)keep=zip YYYYMM ucounty county_name state_fips);
if a;
by zip;


*calculate pct. change;
pct_chg_2000_06=(ne_share200612-ne_share200012)/ne_share200012*100; 
pct_chg_2006_09=(ne_share200912-ne_share200612)/ne_share200612*100; 
pct_chg_2009_13=(ne_share201312-ne_share200912)/ne_share200912*100; 
pct_chg_2000_13=(ne_share201312-ne_share200012)/ne_share200012*100; 
run; 

proc export data=zips_ne_pc 
 OUTFILE= "K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\zips_ne_pc.csv" 
            DBMS=csv REPLACE;
RUN;

data county11; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*sales volume;
keep jurisdiction yyyymm Market_SALE_COUNT ucounty county_name;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;
run;
proc sort data=county11;
by jurisdiction;
proc transpose data=county11 out=table9 prefix=Market_SALE_COUNT;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table9_pc (drop=YYYYMM);;
merge table9 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;

*calculate pct. change;
pct_chg_2000_06=(Market_SALE_COUNT200612-Market_SALE_COUNT200012)/Market_SALE_COUNT200012*100; 
pct_chg_2006_09=(Market_SALE_COUNT200912-Market_SALE_COUNT200612)/Market_SALE_COUNT200612*100; 
pct_chg_2009_13=(Market_SALE_COUNT201312-Market_SALE_COUNT200912)/Market_SALE_COUNT200912*100; 
pct_chg_2000_13=(Market_SALE_COUNT201312-Market_SALE_COUNT200012)/Market_SALE_COUNT200012*100; 

run;
proc sort data=table9_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]Sales Volume Mkt!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table9_pc;
	put  Market_SALE_COUNT200012 Market_SALE_COUNT200612 Market_SALE_COUNT200912 Market_SALE_COUNT201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;

	
data county12; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*sales volume;
keep jurisdiction yyyymm pct_market ucounty county_name;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;
run;
proc sort data=county12;
by jurisdiction;
proc transpose data=county12 out=table10 prefix=pct_market;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table10_pc (drop=YYYYMM);;
merge table10 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;

*calculate pct. change;
pct_chg_2000_06=(pct_market200612-pct_market200012)/pct_market200012*100; 
pct_chg_2006_09=(pct_market200912-pct_market200612)/pct_market200612*100; 
pct_chg_2009_13=(pct_market201312-pct_market200912)/pct_market200912*100; 
pct_chg_2000_13=(pct_market201312-pct_market200012)/pct_market200012*100; 

run;
proc sort data=table10_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]MktSale!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table10_pc;
	put  pct_market200012 pct_market200612 pct_market200912 pct_market201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;


data county13; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*mean sales price;
keep jurisdiction yyyymm Market_sale_mean ucounty county_name; *UNADJUSTED FOR INFLATION;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;

run;
proc sort data=county13;
by jurisdiction;
proc transpose data=county13 out=table11 prefix=Market_sale_mean;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table11_pc (drop=YYYYMM);;
merge table11 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;
%dollar_convert_month(market_sale_MEAN200012, market_sale_MEAN200012r, 12, 2000, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
%dollar_convert_month(market_sale_MEAN200612, market_sale_MEAN200612r, 12, 2006, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
%dollar_convert_month(market_sale_MEAN200912, market_sale_MEAN200912r, 12, 2009, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );

*calculate pct. change;
pct_chg_2000_06=(market_sale_MEAN200612r-market_sale_MEAN200012r)/market_sale_MEAN200012r*100; 
pct_chg_2006_09=(market_sale_MEAN200912r-market_sale_MEAN200612r)/market_sale_MEAN200612r*100; 
pct_chg_2009_13=(market_sale_MEAN201312-market_sale_MEAN200912r)/market_sale_MEAN200912r*100; 
pct_chg_2000_13=(market_sale_MEAN201312-market_sale_MEAN200012r)/market_sale_MEAN200012r*100; 

run;
proc sort data=table11_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]Mkt Sales Price!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table11_pc;
	put  market_sale_MEAN200012r market_sale_MEAN200612r market_sale_MEAN200912r market_sale_MEAN201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;

data county14; *reference months only;
	set county2; 

if yyyymm in (200012 200612 200912 201312);

*mean sales price;
keep jurisdiction yyyymm total_sale_med ucounty county_name; *UNADJUSTED FOR INFLATION;

*if ucounty in ("00001" "00002" "11001" "00004" "00005");
if ui_order ne .;

run;
proc sort data=county14;
by jurisdiction;
proc transpose data=county14 out=table12 prefix=total_sale_med;
id yyyymm;
by jurisdiction;
run;
proc sort data=county2;
by jurisdiction;
data table12_pc (drop=YYYYMM);;
merge table12 (in=a) county2 (where=(YYYYMM=201401)keep=jurisdiction ui_order YYYYMM);
if a;
by jurisdiction;
%dollar_convert_month(total_sale_med200012, total_sale_med200012r, 12, 2000, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
%dollar_convert_month(total_sale_med200612, total_sale_med200612r, 12, 2006, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
%dollar_convert_month(total_sale_med200912, total_sale_med200912r, 12, 2009, 12, 2013, quiet=Y, mprint=N, series=CUUR0000SA0L2 );

*calculate pct. change;
pct_chg_2000_06=(total_sale_med200612r-total_sale_med200012r)/total_sale_med200012r*100; 
pct_chg_2006_09=(total_sale_med200912r-total_sale_med200612r)/total_sale_med200612r*100; 
pct_chg_2009_13=(total_sale_med201312-total_sale_med200912r)/total_sale_med200912r*100; 
pct_chg_2000_13=(total_sale_med201312-total_sale_med200012r)/total_sale_med200012r*100; 

run;
proc sort data=table12_pc;
by ui_order;
run;
filename outexc dde "Excel|K:\Metro\PTatian\DCData\Projects\CAFN\Final Report Proposal\[CAFN Table Shells.xls]Median Sales Price!R5C2:R20C9" ;

data _null_ ;
	file outexc lrecl=65000;
	set table12_pc;
	put  total_sale_med200012r total_sale_med200612r total_sale_med200912r total_sale_med201312 pct_chg_2000_06 pct_chg_2006_09 pct_chg_2009_13 pct_chg_2000_13

	;
	run;
