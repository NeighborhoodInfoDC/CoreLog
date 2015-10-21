/**************************************************************************
 Program:  MarketTrends_2014.sas
 Library:  Corelog
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey
 Created:  4/27/14
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description: Preps and Labels Corelogic Market Trends Data files for DC Region. 

 Modifications: 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";


** Define libraries **;
%DCData_lib( CoreLog )
libname raw "L:\Libraries\CoreLog\Raw";


%read_corelogic_update(
	filedate=201401,
	finalize=Y,
	revisions=New file. Data through 01/2014.,
	EndMonth=01,
	EndYear=2014

);
