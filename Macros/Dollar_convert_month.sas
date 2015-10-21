/* Dollar_convert_month.sas   
   Converts dollars using CPI.
  
   Source URL:  http://data.bls.gov/cgi-bin/srgate
     U.S. All items, 1982-84=100 - CUUR0000SA0 
     U.S. All items less shelter, 1982-84=100 - CUUR0000SA0L2 
  
   NB:  Program written for SAS Version 9.1
  
   09/03/09  L Hendey Adjusted Dollar_Convert.sas to Handle Monthly CPI_NS  CUUR0000SA0L2 (All items less shelter). 
   10/26/09  L Hendey Added Aug and Sep 2009
   01/21/10  L Hendey Added Oct-Dec 2009
   09/23/10  L Hendey Added Jan-Aug 2010 and adapted for 2010 
   03/04/11  L Hendey Added Sept 2010- Jan 2011 and adapted for 2011
   07/12/11  L Hendey Added Feb - May 2011
   08/30/11  L Hendey Added Jun - July 2011
   09/08/11  L Hendey Converted dates entered to numeric format, added series CUUR0000SA0
   09/19/11  L Hendey Added Aug 2011
   11/18/11	 R Grace Added Sept and Oct 2011
   01/31/12	 R Grace Added Nov and Dec 2011
   03/21/12	 R Grace Added Jan and Feb 2012
   03/29/12  L Hendey Updated for 2012
   03/21/12	 R Grace Added Jan and Feb 2012
   05/16/12  R Grace added Mar and Apr 2012
   07/31/12  R Grace Added May and June 2012
   08/20/12  R Grace Added July 2012
   03/08/13  R Grace Added August - December 2012, January 2013
   07/25/13  R Grace Added February - June 2013
   10/09/13  R Grace Added July and August 2013
	03/04/14 S Zhang Added Sept 2013 - Jan 2014
 ****************************************************************************/

%macro Dollar_convert_month( amount1, amount2, from_m, from_y, to_m, to_y, series=CUUR0000SA0, quiet=Y, mprint=N );


  %push_option( mprint, quiet=y )
  
  %if %upcase( &mprint ) = Y %then %do;
    options mprint;
  %end;
  %else %if %upcase( &mprint ) = N %then %do;
    options nomprint;
  %end;

  %global _dcnv_count;

  %local _i MIN_YEAR MAX_YEAR _dcnv_array m y;
  
  %let MIN_YEAR = 1979;
  %let MAX_YEAR = 2014;

    %let series = %upcase( &series );
 %if &series = CUUR0000SA0 %then %do;
    %************************************************** 
        Consumer Price Index - All Urban Consumers
        Series Id:    CUUR0000SA0
        Not Seasonally Adjusted
        Area:         U.S. city average
        Item:         All items
        Base Period:  1982-84=100
    ***************************************************;
  %let	CPI_11979	=	68.3;
  %let	CPI_21979	=	69.1;
  %let	CPI_31979	=	69.8;
  %let	CPI_41979	=	70.6;
  %let	CPI_51979	=	71.5;
  %let	CPI_61979	=	72.3;
  %let	CPI_71979	=	73.1;
  %let	CPI_81979	=	73.8;
  %let	CPI_91979	=	74.6;
  %let	CPI_101979	=	75.2;
  %let	CPI_111979	=	75.9;
  %let	CPI_121979	=	76.7;
  %let	CPI_11980	=	77.8;
  %let	CPI_21980	=	78.9;
  %let	CPI_31980	=	80.1;
  %let	CPI_41980	=	81;
  %let	CPI_51980	=	81.8;
  %let	CPI_61980	=	82.7;
  %let	CPI_71980	=	82.7;
  %let	CPI_81980	=	83.3;
  %let	CPI_91980	=	84;
  %let	CPI_101980	=	84.8;
  %let	CPI_111980	=	85.5;
  %let	CPI_121980	=	86.3;
  %let	CPI_11981	=	87;
  %let	CPI_21981	=	87.9;
  %let	CPI_31981	=	88.5;
  %let	CPI_41981	=	89.1;
  %let	CPI_51981	=	89.8;
  %let	CPI_61981	=	90.6;
  %let	CPI_71981	=	91.6;
  %let	CPI_81981	=	92.3;
  %let	CPI_91981	=	93.2;
  %let	CPI_101981	=	93.4;
  %let	CPI_111981	=	93.7;
  %let	CPI_121981	=	94;
  %let	CPI_11982	=	94.3;
  %let	CPI_21982	=	94.6;
  %let	CPI_31982	=	94.5;
  %let	CPI_41982	=	94.9;
  %let	CPI_51982	=	95.8;
  %let	CPI_61982	=	97;
  %let	CPI_71982	=	97.5;
  %let	CPI_81982	=	97.7;
  %let	CPI_91982	=	97.9;
  %let	CPI_101982	=	98.2;
  %let	CPI_111982	=	98;
  %let	CPI_121982	=	97.6;
  %let	CPI_11983	=	97.8;
  %let	CPI_21983	=	97.9;
  %let	CPI_31983	=	97.9;
  %let	CPI_41983	=	98.6;
  %let	CPI_51983	=	99.2;
  %let	CPI_61983	=	99.5;
  %let	CPI_71983	=	99.9;
  %let	CPI_81983	=	100.2;
  %let	CPI_91983	=	100.7;
  %let	CPI_101983	=	101;
  %let	CPI_111983	=	101.2;
  %let	CPI_121983	=	101.3;
  %let	CPI_11984	=	101.9;
  %let	CPI_21984	=	102.4;
  %let	CPI_31984	=	102.6;
  %let	CPI_41984	=	103.1;
  %let	CPI_51984	=	103.4;
  %let	CPI_61984	=	103.7;
  %let	CPI_71984	=	104.1;
  %let	CPI_81984	=	104.5;
  %let	CPI_91984	=	105;
  %let	CPI_101984	=	105.3;
  %let	CPI_111984	=	105.3;
  %let	CPI_121984	=	105.3;
  %let	CPI_11985	=	105.5;
  %let	CPI_21985	=	106;
  %let	CPI_31985	=	106.4;
  %let	CPI_41985	=	106.9;
  %let	CPI_51985	=	107.3;
  %let	CPI_61985	=	107.6;
  %let	CPI_71985	=	107.8;
  %let	CPI_81985	=	108;
  %let	CPI_91985	=	108.3;
  %let	CPI_101985	=	108.7;
  %let	CPI_111985	=	109;
  %let	CPI_121985	=	109.3;
  %let	CPI_11986	=	109.6;
  %let	CPI_21986	=	109.3;
  %let	CPI_31986	=	108.8;
  %let	CPI_41986	=	108.6;
  %let	CPI_51986	=	108.9;
  %let	CPI_61986	=	109.5;
  %let	CPI_71986	=	109.5;
  %let	CPI_81986	=	109.7;
  %let	CPI_91986	=	110.2;
  %let	CPI_101986	=	110.3;
  %let	CPI_111986	=	110.4;
  %let	CPI_121986	=	110.5;
  %let	CPI_11987	=	111.2;
  %let	CPI_21987	=	111.6;
  %let	CPI_31987	=	112.1;
  %let	CPI_41987	=	112.7;
  %let	CPI_51987	=	113.1;
  %let	CPI_61987	=	113.5;
  %let	CPI_71987	=	113.8;
  %let	CPI_81987	=	114.4;
  %let	CPI_91987	=	115;
  %let	CPI_101987	=	115.3;
  %let	CPI_111987	=	115.4;
  %let	CPI_121987	=	115.4;
  %let	CPI_11988	=	115.7;
  %let	CPI_21988	=	116;
  %let	CPI_31988	=	116.5;
  %let	CPI_41988	=	117.1;
  %let	CPI_51988	=	117.5;
  %let	CPI_61988	=	118;
  %let	CPI_71988	=	118.5;
  %let	CPI_81988	=	119;
  %let	CPI_91988	=	119.8;
  %let	CPI_101988	=	120.2;
  %let	CPI_111988	=	120.3;
  %let	CPI_121988	=	120.5;
  %let	CPI_11989	=	121.1;
  %let	CPI_21989	=	121.6;
  %let	CPI_31989	=	122.3;
  %let	CPI_41989	=	123.1;
  %let	CPI_51989	=	123.8;
  %let	CPI_61989	=	124.1;
  %let	CPI_71989	=	124.4;
  %let	CPI_81989	=	124.6;
  %let	CPI_91989	=	125;
  %let	CPI_101989	=	125.6;
  %let	CPI_111989	=	125.9;
  %let	CPI_121989	=	126.1;
  %let	CPI_11990	=	127.4;
  %let	CPI_21990	=	128;
  %let	CPI_31990	=	128.7;
  %let	CPI_41990	=	128.9;
  %let	CPI_51990	=	129.2;
  %let	CPI_61990	=	129.9;
  %let	CPI_71990	=	130.4;
  %let	CPI_81990	=	131.6;
  %let	CPI_91990	=	132.7;
  %let	CPI_101990	=	133.5;
  %let	CPI_111990	=	133.8;
  %let	CPI_121990	=	133.8;
  %let	CPI_11991	=	134.6;
  %let	CPI_21991	=	134.8;
  %let	CPI_31991	=	135;
  %let	CPI_41991	=	135.2;
  %let	CPI_51991	=	135.6;
  %let	CPI_61991	=	136;
  %let	CPI_71991	=	136.2;
  %let	CPI_81991	=	136.6;
  %let	CPI_91991	=	137.2;
  %let	CPI_101991	=	137.4;
  %let	CPI_111991	=	137.8;
  %let	CPI_121991	=	137.9;
  %let	CPI_11992	=	138.1;
  %let	CPI_21992	=	138.6;
  %let	CPI_31992	=	139.3;
  %let	CPI_41992	=	139.5;
  %let	CPI_51992	=	139.7;
  %let	CPI_61992	=	140.2;
  %let	CPI_71992	=	140.5;
  %let	CPI_81992	=	140.9;
  %let	CPI_91992	=	141.3;
  %let	CPI_101992	=	141.8;
  %let	CPI_111992	=	142;
  %let	CPI_121992	=	141.9;
  %let	CPI_11993	=	142.6;
  %let	CPI_21993	=	143.1;
  %let	CPI_31993	=	143.6;
  %let	CPI_41993	=	144;
  %let	CPI_51993	=	144.2;
  %let	CPI_61993	=	144.4;
  %let	CPI_71993	=	144.4;
  %let	CPI_81993	=	144.8;
  %let	CPI_91993	=	145.1;
  %let	CPI_101993	=	145.7;
  %let	CPI_111993	=	145.8;
  %let	CPI_121993	=	145.8;
  %let	CPI_11994	=	146.2;
  %let	CPI_21994	=	146.7;
  %let	CPI_31994	=	147.2;
  %let	CPI_41994	=	147.4;
  %let	CPI_51994	=	147.5;
  %let	CPI_61994	=	148;
  %let	CPI_71994	=	148.4;
  %let	CPI_81994	=	149;
  %let	CPI_91994	=	149.4;
  %let	CPI_101994	=	149.5;
  %let	CPI_111994	=	149.7;
  %let	CPI_121994	=	149.7;
  %let	CPI_11995	=	150.3;
  %let	CPI_21995	=	150.9;
  %let	CPI_31995	=	151.4;
  %let	CPI_41995	=	151.9;
  %let	CPI_51995	=	152.2;
  %let	CPI_61995	=	152.5;
  %let	CPI_71995	=	152.5;
  %let	CPI_81995	=	152.9;
  %let	CPI_91995	=	153.2;
  %let	CPI_101995	=	153.7;
  %let	CPI_111995	=	153.6;
  %let	CPI_121995	=	153.5;
  %let	CPI_11996	=	154.4;
  %let	CPI_21996	=	154.9;
  %let	CPI_31996	=	155.7;
  %let	CPI_41996	=	156.3;
  %let	CPI_51996	=	156.6;
  %let	CPI_61996	=	156.7;
  %let	CPI_71996	=	157;
  %let	CPI_81996	=	157.3;
  %let	CPI_91996	=	157.8;
  %let	CPI_101996	=	158.3;
  %let	CPI_111996	=	158.6;
  %let	CPI_121996	=	158.6;
  %let	CPI_11997	=	159.1;
  %let	CPI_21997	=	159.6;
  %let	CPI_31997	=	160;
  %let	CPI_41997	=	160.2;
  %let	CPI_51997	=	160.1;
  %let	CPI_61997	=	160.3;
  %let	CPI_71997	=	160.5;
  %let	CPI_81997	=	160.8;
  %let	CPI_91997	=	161.2;
  %let	CPI_101997	=	161.6;
  %let	CPI_111997	=	161.5;
  %let	CPI_121997	=	161.3;
  %let	CPI_11998	=	161.6;
  %let	CPI_21998	=	161.9;
  %let	CPI_31998	=	162.2;
  %let	CPI_41998	=	162.5;
  %let	CPI_51998	=	162.8;
  %let	CPI_61998	=	163;
  %let	CPI_71998	=	163.2;
  %let	CPI_81998	=	163.4;
  %let	CPI_91998	=	163.6;
  %let	CPI_101998	=	164;
  %let	CPI_111998	=	164;
  %let	CPI_121998	=	163.9;
  %let	CPI_11999	=	164.3;
  %let	CPI_21999	=	164.5;
  %let	CPI_31999	=	165;
  %let	CPI_41999	=	166.2;
  %let	CPI_51999	=	166.2;
  %let	CPI_61999	=	166.2;
  %let	CPI_71999	=	166.7;
  %let	CPI_81999	=	167.1;
  %let	CPI_91999	=	167.9;
  %let	CPI_101999	=	168.2;
  %let	CPI_111999	=	168.3;
  %let	CPI_121999	=	168.3;
  %let	CPI_12000	=	168.8;
  %let	CPI_22000	=	169.8;
  %let	CPI_32000	=	171.2;
  %let	CPI_42000	=	171.3;
  %let	CPI_52000	=	171.5;
  %let	CPI_62000	=	172.4;
  %let	CPI_72000	=	172.8;
  %let	CPI_82000	=	172.8;
  %let	CPI_92000	=	173.7;
  %let	CPI_102000	=	174;
  %let	CPI_112000	=	174.1;
  %let	CPI_122000	=	174;
  %let	CPI_12001	=	175.1;
  %let	CPI_22001	=	175.8;
  %let	CPI_32001	=	176.2;
  %let	CPI_42001	=	176.9;
  %let	CPI_52001	=	177.7;
  %let	CPI_62001	=	178;
  %let	CPI_72001	=	177.5;
  %let	CPI_82001	=	177.5;
  %let	CPI_92001	=	178.3;
  %let	CPI_102001	=	177.7;
  %let	CPI_112001	=	177.4;
  %let	CPI_122001	=	176.7;
  %let	CPI_12002	=	177.1;
  %let	CPI_22002	=	177.8;
  %let	CPI_32002	=	178.8;
  %let	CPI_42002	=	179.8;
  %let	CPI_52002	=	179.8;
  %let	CPI_62002	=	179.9;
  %let	CPI_72002	=	180.1;
  %let	CPI_82002	=	180.7;
  %let	CPI_92002	=	181;
  %let	CPI_102002	=	181.3;
  %let	CPI_112002	=	181.3;
  %let	CPI_122002	=	180.9;
  %let	CPI_12003	=	181.7;
  %let	CPI_22003	=	183.1;
  %let	CPI_32003	=	184.2;
  %let	CPI_42003	=	183.8;
  %let	CPI_52003	=	183.5;
  %let	CPI_62003	=	183.7;
  %let	CPI_72003	=	183.9;
  %let	CPI_82003	=	184.6;
  %let	CPI_92003	=	185.2;
  %let	CPI_102003	=	185;
  %let	CPI_112003	=	184.5;
  %let	CPI_122003	=	184.3;
  %let	CPI_12004	=	185.2;
  %let	CPI_22004	=	186.2;
  %let	CPI_32004	=	187.4;
  %let	CPI_42004	=	188;
  %let	CPI_52004	=	189.1;
  %let	CPI_62004	=	189.7;
  %let	CPI_72004	=	189.4;
  %let	CPI_82004	=	189.5;
  %let	CPI_92004	=	189.9;
  %let	CPI_102004	=	190.9;
  %let	CPI_112004	=	191;
  %let	CPI_122004	=	190.3;
  %let	CPI_12005	=	190.7;
  %let	CPI_22005	=	191.8;
  %let	CPI_32005	=	193.3;
  %let	CPI_42005	=	194.6;
  %let	CPI_52005	=	194.4;
  %let	CPI_62005	=	194.5;
  %let	CPI_72005	=	195.4;
  %let	CPI_82005	=	196.4;
  %let	CPI_92005	=	198.8;
  %let	CPI_102005	=	199.2;
  %let	CPI_112005	=	197.6;
  %let	CPI_122005	=	196.8;
  %let	CPI_12006	=	198.3;
  %let	CPI_22006	=	198.7;
  %let	CPI_32006	=	199.8;
  %let	CPI_42006	=	201.5;
  %let	CPI_52006	=	202.5;
  %let	CPI_62006	=	202.9;
  %let	CPI_72006	=	203.5;
  %let	CPI_82006	=	203.9;
  %let	CPI_92006	=	202.9;
  %let	CPI_102006	=	201.8;
  %let	CPI_112006	=	201.5;
  %let	CPI_122006	=	201.8;
  %let	CPI_12007	=	202.416;
  %let	CPI_22007	=	203.499;
  %let	CPI_32007	=	205.352;
  %let	CPI_42007	=	206.686;
  %let	CPI_52007	=	207.949;
  %let	CPI_62007	=	208.352;
  %let	CPI_72007	=	208.299;
  %let	CPI_82007	=	207.917;
  %let	CPI_92007	=	208.49;
  %let	CPI_102007	=	208.936;
  %let	CPI_112007	=	210.177;
  %let	CPI_122007	=	210.036;
  %let	CPI_12008	=	211.08;
  %let	CPI_22008	=	211.693;
  %let	CPI_32008	=	213.528;
  %let	CPI_42008	=	214.823;
  %let	CPI_52008	=	216.632;
  %let	CPI_62008	=	218.815;
  %let	CPI_72008	=	219.964;
  %let	CPI_82008	=	219.086;
  %let	CPI_92008	=	218.783;
  %let	CPI_102008	=	216.573;
  %let	CPI_112008	=	212.425;
  %let	CPI_122008	=	210.228;
  %let	CPI_12009	=	211.143;
  %let	CPI_22009	=	212.193;
  %let	CPI_32009	=	212.709;
  %let	CPI_42009	=	213.24;
  %let	CPI_52009	=	213.856;
  %let	CPI_62009	=	215.693;
  %let	CPI_72009	=	215.351;
  %let	CPI_82009	=	215.834;
  %let	CPI_92009	=	215.969;
  %let	CPI_102009	=	216.177;
  %let	CPI_112009	=	216.33;
  %let	CPI_122009	=	215.949;
  %let	CPI_12010	=	216.687;
  %let	CPI_22010	=	216.741;
  %let	CPI_32010	=	217.631;
  %let	CPI_42010	=	218.009;
  %let	CPI_52010	=	218.178;
  %let	CPI_62010	=	217.965;
  %let	CPI_72010	=	218.011;
  %let	CPI_82010	=	218.312;
  %let	CPI_92010	=	218.439;
  %let	CPI_102010	=	218.711;
  %let	CPI_112010	=	218.803;
  %let	CPI_122010	=	219.179;
  %let	CPI_12011	=	220.223;
  %let	CPI_22011	=	221.309;
  %let	CPI_32011	=	223.467;
  %let	CPI_42011	=	224.906;
  %let	CPI_52011	=	225.964;
  %let	CPI_62011	=	225.722;
  %let	CPI_72011	=	225.922;
  %let	CPI_82011	=	226.545;
  %let	CPI_92011	=	226.889;
  %let	CPI_102011	=	226.421;
  %let	CPI_112011	=	226.230;
  %let	CPI_122011	=	225.672;
  %let	CPI_12012	=	226.665;
  %let	CPI_22012	=	227.663;
  %let	CPI_32012	=	229.392;
  %let	CPI_42012	=	230.085;
  %let	CPI_52012	=	229.815;
  %let	CPI_62012	=	229.478;
  %let	CPI_72012	=	229.104;
  %let	CPI_82012	=	230.379;				
  %let	CPI_92012	=	231.407;
  %let	CPI_102012	=	231.317;
  %let	CPI_112012	=	230.221;
  %let	CPI_122012	=	229.601;
  %let	CPI_12013	=	230.280;
  %let	CPI_22013	=	232.166;
  %let	CPI_32013	=	232.773;
  %let	CPI_42013	=	232.531;
  %let	CPI_52013	=	232.945;
  %let	CPI_62013	=	233.504;
  %let	CPI_72013	=	233.596;
  %let	CPI_82013	=	233.877;
  %let	CPI_92013	=	234.149;
  %let	CPI_102013	=	233.546;
  %let	CPI_112013	=	233.069;
  %let	CPI_122013	=	233.049;
  %let	CPI_12014	=	233.916;
  %let	CPI_22014	=	.;
  %let	CPI_32014	=	.;
  %let	CPI_42014	=	.;
   %let	CPI_52014	=	.;
  %let	CPI_62014	=	.;
  %let	CPI_72014	=	.;
  %let	CPI_82014	=	.;
  %let	CPI_92014	=	.;
  %let	CPI_102014	=	.;
  %let	CPI_112014	=	.;
    %let	CPI_122014	=	.;

%end;
  %else %if &series = CUUR0000SA0L2 %then %do;
    %************************************************** 
        Consumer Price Index - All Urban Consumers
		Series Id:    CUUR0000SA0L2
		Not Seasonally Adjusted
		Area:         U.S. city average
		Item:         All items less shelter
		Base Period:  1982-84=100
    ***************************************************;
  %let	CPI_11979	=	70.3; 
  %let	CPI_21979	=	71; 
  %let	CPI_31979	=	71.7;
  %let	CPI_41979	=	72.5;
  %let	CPI_51979	=	73.4;
  %let	CPI_61979	=	74.2;
  %let	CPI_71979	=	74.9;
  %let	CPI_81979	=	75.4;
  %let	CPI_91979	=	76.1;
  %let	CPI_101979	=	76.6;
  %let	CPI_111979	=	77;
  %let	CPI_121979	=	77.7;
  %let	CPI_11980	=	78.7; 
  %let	CPI_21980	=	79.8;
  %let	CPI_31980	=	80.9;
  %let	CPI_41980	=	81.6;
  %let	CPI_51980	=	82.2;
  %let	CPI_61980	=	82.7;
  %let	CPI_71980	=	83.2;
  %let	CPI_81980	=	84;
  %let	CPI_91980	=	84.9;
  %let	CPI_101980	=	85.3;
  %let	CPI_111980	=	85.8;
  %let	CPI_121980	=	86.3;
  %let	CPI_11981	=	87.2;
  %let	CPI_21981	=	88.5;
  %let	CPI_31981	=	89.2;
  %let	CPI_41981	=	89.8;
  %let	CPI_51981	=	90.2;
  %let	CPI_61981	=	90.8;
  %let	CPI_71981	=	91.5;
  %let	CPI_81981	=	92;
  %let	CPI_91981	=	92.8;
  %let	CPI_101981	=	93.1;
  %let	CPI_111981	=	93.5;
  %let	CPI_121981	=	93.7;
  %let	CPI_11982	=	94.2;
  %let	CPI_21982	=	94.5;
  %let	CPI_31982	=	94.5;
  %let	CPI_41982	=	94.6;
  %let	CPI_51982	=	95.3;
  %let	CPI_61982	=	96.4;
  %let	CPI_71982	=	96.9;
  %let	CPI_81982	=	97.1;
  %let	CPI_91982	=	97.5;
  %let	CPI_101982	=	97.9;
  %let	CPI_111982	=	97.9;
  %let	CPI_121982	=	98;
  %let	CPI_11983	=	98.1;
  %let	CPI_21983	=	98.1;
  %let	CPI_31983	=	98.1;
  %let	CPI_41983	=	98.9;
  %let	CPI_51983	=	99.4;
  %let	CPI_61983	=	99.8;
  %let	CPI_71983	=	100.2;
  %let	CPI_81983	=	100.5;
  %let	CPI_91983	=	101;
  %let	CPI_101983	=	101.2;
  %let	CPI_111983	=	101.3;
  %let	CPI_121983	=	101.5;
  %let	CPI_11984	=	102;
  %let	CPI_21984	=	102.6;
  %let	CPI_31984	=	102.8;
  %let	CPI_41984	=	103.2;
  %let	CPI_51984	=	103.5;
  %let	CPI_61984	=	103.8;
  %let	CPI_71984	=	104.1;
  %let	CPI_81984	=	104.5;
  %let	CPI_91984	=	105;
  %let	CPI_101984	=	105.2;
  %let	CPI_111984	=	105.1;
  %let	CPI_121984	=	105.1;
  %let	CPI_11985	=	105.3;
  %let	CPI_21985	=	105.6;
  %let	CPI_31985	=	106.2;
  %let	CPI_41985	=	106.6;
  %let	CPI_51985	=	106.8;
  %let	CPI_61985	=	107.2;
  %let	CPI_71985	=	107.2;
  %let	CPI_81985	=	107.3;
  %let	CPI_91985	=	107.6;
  %let	CPI_101985	=	107.9;
  %let	CPI_111985	=	108.2;
  %let	CPI_121985	=	108.4;
  %let	CPI_11986	=	108.7;
  %let	CPI_21986	=	108.2;
  %let	CPI_31986	=	107.5;
  %let	CPI_41986	=	106.9;
  %let	CPI_51986	=	107.3;
  %let	CPI_61986	=	107.9;
  %let	CPI_71986	=	107.8;
  %let	CPI_81986	=	107.9;
  %let	CPI_91986	=	108.4;
  %let	CPI_101986	=	108.4;
  %let	CPI_111986	=	108.5;
  %let	CPI_121986	=	108.6;
  %let	CPI_11987	=	109.3;
  %let	CPI_21987	=	109.7;
  %let	CPI_31987	=	110.2;
  %let	CPI_41987	=	110.8;
  %let	CPI_51987	=	111.1;
  %let	CPI_61987	=	111.7;
  %let	CPI_71987	=	111.8;
  %let	CPI_81987	=	112.3;
  %let	CPI_91987	=	113;
  %let	CPI_101987	=	113.2;
  %let	CPI_111987	=	113.3;
  %let	CPI_121987	=	113.2;
  %let	CPI_11988	=	113.3;
  %let	CPI_21988	=	113.5;
  %let	CPI_31988	=	114;
  %let	CPI_41988	=	114.7;
  %let	CPI_51988	=	115.2;
  %let	CPI_61988	=	115.7;
  %let	CPI_71988	=	116.1;
  %let	CPI_81988	=	116.5;
  %let	CPI_91988	=	117.5;
  %let	CPI_101988	=	117.9;
  %let	CPI_111988	=	118;
  %let	CPI_121988	=	118.1;
  %let	CPI_11989	=	118.7;
  %let	CPI_21989	=	119.2;
  %let	CPI_31989	=	119.9;
  %let	CPI_41989	=	121;
  %let	CPI_51989	=	121.7;
  %let	CPI_61989	=	122;
  %let	CPI_71989	=	122;
  %let	CPI_81989	=	122;
  %let	CPI_91989	=	122.6;
  %let	CPI_101989	=	123.1;
  %let	CPI_111989	=	123.3;
  %let	CPI_121989	=	123.5;
  %let	CPI_11990	=	125;
  %let	CPI_21990	=	125.7;
  %let	CPI_31990	=	126.2;
  %let	CPI_41990	=	126.5;
  %let	CPI_51990	=	126.7;
  %let	CPI_61990	=	127.3;
  %let	CPI_71990	=	127.5;
  %let	CPI_81990	=	128.6;
  %let	CPI_91990	=	130.1;
  %let	CPI_101990	=	131.2;
  %let	CPI_111990	=	131.5;
  %let	CPI_121990	=	131.5;
  %let	CPI_11991	=	132.1;
  %let	CPI_21991	=	132.2;
  %let	CPI_31991	=	132.2;
  %let	CPI_41991	=	132.6;
  %let	CPI_51991	=	133.1;
  %let	CPI_61991	=	133.3;
  %let	CPI_71991	=	133.3;
  %let	CPI_81991	=	133.7;
  %let	CPI_91991	=	134.5;
  %let	CPI_101991	=	134.6;
  %let	CPI_111991	=	135;
  %let	CPI_121991	=	135;
  %let	CPI_11992	=	135.1;
  %let	CPI_21992	=	135.5;
  %let	CPI_31992	=	136.2;
  %let	CPI_41992	=	136.6;
  %let	CPI_51992	=	136.9;
  %let	CPI_61992	=	137.2;
  %let	CPI_71992	=	137.3;
  %let	CPI_81992	=	137.7;
  %let	CPI_91992	=	138.4;
  %let	CPI_101992	=	138.9;
  %let	CPI_111992	=	139.2;
  %let	CPI_121992	=	139.1;
  %let	CPI_11993	=	139.5;
  %let	CPI_21993	=	140;
  %let	CPI_31993	=	140.5;
  %let	CPI_41993	=	140.9;
  %let	CPI_51993	=	141.3;
  %let	CPI_61993	=	141.2;
  %let	CPI_71993	=	141.1;
  %let	CPI_81993	=	141.5;
  %let	CPI_91993	=	142;
  %let	CPI_101993	=	142.6;
  %let	CPI_111993	=	142.9;
  %let	CPI_121993	=	142.7;
  %let	CPI_11994	=	142.9;
  %let	CPI_21994	=	143.2;
  %let	CPI_31994	=	143.7;
  %let	CPI_41994	=	144;
  %let	CPI_51994	=	144.2;
  %let	CPI_61994	=	144.6;
  %let	CPI_71994	=	144.9;
  %let	CPI_81994	=	145.5;
  %let	CPI_91994	=	146;
  %let	CPI_101994	=	146.1;
  %let	CPI_111994	=	146.3;
  %let	CPI_121994	=	146.3;
  %let	CPI_11995	=	146.8;
  %let	CPI_21995	=	147.2;
  %let	CPI_31995	=	147.7;
  %let	CPI_41995	=	148.3;
  %let	CPI_51995	=	148.6;
  %let	CPI_61995	=	148.8;
  %let	CPI_71995	=	148.6;
  %let	CPI_81995	=	148.9;
  %let	CPI_91995	=	149.4;
  %let	CPI_101995	=	149.8;
  %let	CPI_111995	=	149.7;
  %let	CPI_121995	=	149.6;
  %let	CPI_11996	=	150.3;
  %let	CPI_21996	=	150.8;
  %let	CPI_31996	=	151.6;
  %let	CPI_41996	=	152.4;
  %let	CPI_51996	=	152.8;
  %let	CPI_61996	=	152.8;
  %let	CPI_71996	=	152.8;
  %let	CPI_81996	=	152.9;
  %let	CPI_91996	=	153.8;
  %let	CPI_101996	=	154.2;
  %let	CPI_111996	=	154.6;
  %let	CPI_121996	=	154.7;
  %let	CPI_11997	=	155;
  %let	CPI_21997	=	155.3;
  %let	CPI_31997	=	155.6;
  %let	CPI_41997	=	155.8;
  %let	CPI_51997	=	155.7;
  %let	CPI_61997	=	155.7;
  %let	CPI_71997	=	155.6;
  %let	CPI_81997	=	155.9;
  %let	CPI_91997	=	156.6;
  %let	CPI_101997	=	156.9;
  %let	CPI_111997	=	156.8;
  %let	CPI_121997	=	156.4;
  %let	CPI_11998	=	156.4;
  %let	CPI_21998	=	156.4;
  %let	CPI_31998	=	156.5;
  %let	CPI_41998	=	156.9;
  %let	CPI_51998	=	157.3;
  %let	CPI_61998	=	157.3;
  %let	CPI_71998	=	157.3;
  %let	CPI_81998	=	157.4;
  %let	CPI_91998	=	157.6;
  %let	CPI_101998	=	157.9;
  %let	CPI_111998	=	157.9;
  %let	CPI_121998	=	157.8;
  %let	CPI_11999	=	158.1;
  %let	CPI_21999	=	158.1;
  %let	CPI_31999	=	158.5;
  %let	CPI_41999	=	159.9;
  %let	CPI_51999	=	159.9;
  %let	CPI_61999	=	159.7;
  %let	CPI_71999	=	160.1;
  %let	CPI_81999	=	160.6;
  %let	CPI_91999	=	161.6;
  %let	CPI_101999	=	162;
  %let	CPI_111999	=	162.1;
  %let	CPI_121999	=	162.1;
  %let	CPI_12000	=	162.3;
  %let	CPI_22000	=	163.3;
  %let	CPI_32000	=	164.8;
  %let	CPI_42000	=	164.9;
  %let	CPI_52000	=	165.1;
  %let	CPI_62000	=	166;
  %let	CPI_72000	=	166.2;
  %let	CPI_82000	=	166;
  %let	CPI_92000	=	167.4;
  %let	CPI_102000	=	167.5;
  %let	CPI_112000	=	167.7;
  %let	CPI_122000	=	167.5;
  %let	CPI_12001	=	168.6;
  %let	CPI_22001	=	169.1;
  %let	CPI_32001	=	169.2;
  %let	CPI_42001	=	170.1;
  %let	CPI_52001	=	170.9;
  %let	CPI_62001	=	171;
  %let	CPI_72001	=	170;
  %let	CPI_82001	=	169.7;
  %let	CPI_92001	=	170.9;
  %let	CPI_102001	=	169.9;
  %let	CPI_112001	=	169.3;
  %let	CPI_122001	=	168.2;
  %let	CPI_12002	=	168.4;
  %let	CPI_22002	=	168.7;
  %let	CPI_32002	=	169.7;
  %let	CPI_42002	=	170.9;
  %let	CPI_52002	=	170.9;
  %let	CPI_62002	=	170.9;
  %let	CPI_72002	=	170.9;
  %let	CPI_82002	=	171.3;
  %let	CPI_92002	=	171.9;
  %let	CPI_102002	=	172.2;
  %let	CPI_112002	=	172.3;
  %let	CPI_122002	=	171.7;
  %let	CPI_12003	=	172.3;
  %let	CPI_22003	=	174;
  %let	CPI_32003	=	175.3;
  %let	CPI_42003	=	174.7;
  %let	CPI_52003	=	174.1;
  %let	CPI_62003	=	174.3;
  %let	CPI_72003	=	174.2;
  %let	CPI_82003	=	175;
  %let	CPI_92003	=	176;
  %let	CPI_102003	=	175.5;
  %let	CPI_112003	=	174.9;
  %let	CPI_122003	=	174.7;
  %let	CPI_12004	=	175.6;
  %let	CPI_22004	=	176.7;
  %let	CPI_32004	=	177.6;
  %let	CPI_42004	=	178.2;
  %let	CPI_52004	=	179.6;
  %let	CPI_62004	=	180.2;
  %let	CPI_72004	=	179.6;
  %let	CPI_82004	=	179.5;
  %let	CPI_92004	=	180.1;
  %let	CPI_102004	=	181.4;
  %let	CPI_112004	=	181.9;
  %let	CPI_122004	=	180.9;
  %let	CPI_12005	=	180.9;
  %let	CPI_22005	=	181.9;
  %let	CPI_32005	=	183.2;
  %let	CPI_42005	=	185.1;
  %let	CPI_52005	=	185;
  %let	CPI_62005	=	184.9;
  %let	CPI_72005	=	185.7;
  %let	CPI_82005	=	187.1;
  %let	CPI_92005	=	191;
  %let	CPI_102005	=	191.1;
  %let	CPI_112005	=	189;
  %let	CPI_122005	=	187.7;
  %let	CPI_12006	=	189.3;
  %let	CPI_22006	=	189.4;
  %let	CPI_32006	=	190.3;
  %let	CPI_42006	=	192.3;
  %let	CPI_52006	=	193.5;
  %let	CPI_62006	=	193.7;
  %let	CPI_72006	=	194;
  %let	CPI_82006	=	194.4;
  %let	CPI_92006	=	193.1;
  %let	CPI_102006	=	191.2;
  %let	CPI_112006	=	190.7;
  %let	CPI_122006	=	191.1;
  %let	CPI_12007	=	191.328;
  %let	CPI_22007	=	192.272;
  %let	CPI_32007	=	194.482;
  %let	CPI_42007	=	196.062;
  %let	CPI_52007	=	197.783;
  %let	CPI_62007	=	197.913;
  %let	CPI_72007	=	197.408;
  %let	CPI_82007	=	196.803;
  %let	CPI_92007	=	197.708;
  %let	CPI_102007	=	198.171;
  %let	CPI_112007	=	199.998;
  %let	CPI_122007	=	199.734;
  %let	CPI_12008	=	200.609;
  %let	CPI_22008	=	201.11;
  %let	CPI_32008	=	203.217;
  %let	CPI_42008	=	205.04;
  %let	CPI_52008	=	207.566;
  %let	CPI_62008	=	210.242;
  %let	CPI_72008	=	211.468;
  %let	CPI_82008	=	210.264;
  %let	CPI_92008	=	209.936;
  %let	CPI_102008	=	206.776;
  %let	CPI_112008	=	201.075;
  %let	CPI_122008	=	198.127;
  %let	CPI_12009	=	198.936;
  %let	CPI_22009	=	200.184;
  %let	CPI_32009	=	200.626;
  %let	CPI_42009	=	201.271;
  %let	CPI_52009	=	202.171;
  %let	CPI_62009	=	204.578;
  %let	CPI_72009	=	204.069;
  %let	CPI_82009	=	204.776;
  %let	CPI_92009	=	205.263;
  %let	CPI_102009	=	205.567;
  %let	CPI_112009	=	206.286;
  %let	CPI_122009	=	205.888;
  %let	CPI_12010	=	206.892;
  %let	CPI_22010	=	206.948;
  %let	CPI_32010	=	208.181;
  %let	CPI_42010	=	208.722;
  %let	CPI_52010	=	208.932;
  %let	CPI_62010	=	208.486;
  %let	CPI_72010	=	208.469;
  %let	CPI_82010	=	208.925;
  %let	CPI_92010	=	209.133;
  %let	CPI_102010	=	209.467;
  %let	CPI_112010	=	209.560;
  %let	CPI_122010	=	209.996;
  %let	CPI_12011	=	211.273;
  %let	CPI_22011	=	212.633;
  %let	CPI_32011	=	215.505;
  %let	CPI_42011	=	217.475;
  %let	CPI_52011	=	218.847;
  %let	CPI_62011	=	218.239;
  %let	CPI_72011	=	218.230;
  %let	CPI_82011	=	218.952;
  %let	CPI_92011	=	219.396;
  %let	CPI_102011	=	218.558;
  %let	CPI_112011	=	218.205;
  %let	CPI_122011	=	217.260;
  %let	CPI_12012	=	218.378;
  %let	CPI_22012	=	219.580;
  %let	CPI_32012	=	221.744;
  %let	CPI_42012	=	222.552;
  %let	CPI_52012	=	222.010;
  %let	CPI_62012	=	221.336;
  %let	CPI_72012	=	220.629;
  %let	CPI_82012	=	222.251;
  %let	CPI_92012	=	223.535;
  %let	CPI_102012	=	223.181;
  %let	CPI_112012	=	221.572;
  %let	CPI_122012	=	220.582;
  %let	CPI_12013	=	221.246;
  %let	CPI_22013	=	223.629;	
  %let	CPI_32013	=	224.241;	
  %let	CPI_42013	=	223.774;	
  %let	CPI_52013	=	224.105;	
  %let	CPI_62013	=	224.647;
  %let	CPI_72013	=	224.563;
  %let	CPI_82013	=	224.732;
  %let	CPI_92013	=	224.988;
  %let	CPI_102013	=	223.993;
  %let	CPI_112013	=	223.088;
  %let	CPI_122013	=	222.834;
  %let	CPI_12014	=	223.710;
  %let	CPI_22014	=	.;
  %let	CPI_32014	=	.;
  %let	CPI_42014	=	.;
  %let	CPI_52014	=	.;
  %let	CPI_62014	=	.;
  %let	CPI_72014	=	.;
  %let	CPI_82014	=	.;
  %let	CPI_92014	=	.;
  %let	CPI_102014	=	.;
  %let	CPI_112014	=	.;
  %let	CPI_122014	=	.;
%end;
  %else %do;
    %err_mput( macro=Dollar_convert_month, msg=Invalid SERIES= value: &series )
    %goto exit_macro;
  %end;
  
  %if &_dcnv_count = %then %let _dcnv_count = 1;
  %else %let _dcnv_count = %eval( &_dcnv_count + 1 );

 %let _dcnv_array = _dcnv&_dcnv_count ;


	array &_dcnv_array {1:12,&Min_year:&max_year} _temporary_  
			(
			%do m=1 %to 12; 
			%do y=&min_year %to &max_year;
	  		 &&&CPI_&m.&y.
			%end;
			%end;
			); 



  %let Result = (&amount1) * (&_dcnv_array{&to_m.,&to_y.}/&_dcnv_array{&from_m.,&from_y.});

if (&from_y) < &MIN_YEAR or (&from_y) > &MAX_YEAR then do;
    %if %datatyp(&from_y) = NUMERIC %then %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year FROM=&from_y..  Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
    %else %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year FROM=" &from_y ". Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
  end;
  else if (&to_y) < &MIN_YEAR or (&to_y) > &MAX_YEAR then do;
    %if %datatyp(&to_y) = NUMERIC %then %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year TO=&to_y..  Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
    %else %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year TO=" &to_y ". Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
  end;
  else do;
    &amount2 = (&result);
  end;
	
  %exit_macro:
  
  %if %upcase( &quiet ) = N %then %do;
  	  %note_mput( macro=Dollar_convert_month, msg=TO=&to_m.&to_y. )
  	%note_mput( macro=Dollar_convert_month, msg=FROM=&from_m.&from_y. )
    %note_mput( macro=Dollar_convert_month, msg=Result=&result )
  %end;
  
  %pop_option( mprint, quiet=y )

%mend Dollar_convert_month;

/** End Macro Definition **/


/************ UNCOMMENT TO TEST ****************************;

filename uiautos "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);

options mprint symbolgen nomlogic;
options msglevel=i;

data _null_;

  %dollar_convert_month( 100, amount2, from_m=7, from_y=2011, to_m=2, to_y=1980, quiet=Y, mprint=N, series=CUUR0000SA0);
 put amount2=;
 run;
 

data _null_;

  input amount from_y from_m to_y to_m ;

%dollar_convert_month( amount, amount2, from_m, from_y, to_m, to_y, quiet=Y, mprint=Y, series=CUUR0000SA0);

  
    put amount2= amount= from_y= from_m= to_y= to_m=;
cards;
100 1980 1 2005 12
100 2005 2 1980 11
100 1994 3 2005 10
100 1995 4 2010 9
100 1995 5 2005 8
100 2000 6 2005 7
100 2005 7 1995 6
;

run;

/*****************************************************************/
