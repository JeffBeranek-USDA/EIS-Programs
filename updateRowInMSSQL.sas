
/** update rows in a sybase table   **/
 

/*****************************************************************************/
/* Specify table name in which rows will be updated, and the code to         */
/* specify which rows will be updated.                                       */
/****************************************************************************/

%let pw='Nevsky122023!';
*%let tablenam=PRD_rule;
*%let tablenam=PRD_rule_detail_item;
*%let tablenam=Reporting_unit;
*%let tablenam=Census_reporting_unit;
*%let tablenam=Edit_status;
*%let tablenam=Flag_definition;
*%let tablenam=Master_varname;
%let tablenam=Var_name;
*%let tablenam=Varname_section;
*%let tablenam=Edit_name;
*%let tablenam=Edit_status;
*%let tablenam=Edit_parm;
%let tablenam=Test_deck;
*%let tablenam=Categorical;
*%let tablenam=User_access;
*%let tablenam=Edit_status;
*%LET Set =Latest_survey_response_year=NULL;
*%LET Set =Questionnaire_id=4;
*%LET Set =Original_questionnaire_id=4;
*%let Set = Categorical_flag=1;
*%let Set=Section_sub_order=0;
*%let Set=Section_order=7;
*%let Set=Consistency_failure_flag=0;
*%let Set=Numeric_code=2;
*%let Set=Valid_for_format_flag=0;
%let Set=Varname='viewEditReportingQuestCen.Reporting_state';
*%let Set=Record_locked_flag=1;
*%let Set=Imputation_failure_flag=1;
*%let Set=Edit_failure_flag=0;
*%let Set=Dirty_flag=0;
*%let Set=Edit_failure_msg=NULL;
*%let Set=Published_unit_of_measure='CODES';
*%let Set=Table_type=0;
*%let Set= Max_value=3;
*%let Set=Page_number=NULL;
*%let Set=Item_nonresponse_flag=1;
*%let Set=Sum_detail_indicator=0;
*%let Set = Locked_user_id='beraje';
*%let Set=Latest_survey_response_year=NULL;
*%let Set=Replication_availability_flag=1;
%let Where = Survey_key in (173) and Module_number=30 and Varname='VIEWEDITREPORTINGQUESTCEN.REPORTING_STATE';
*%LET Set =Rep_prd_use_code=0;
*%LET Set =Rep_elmo_use_code=0;
*%LET Set =Rep_census_use_code=0;
*%let Where = Survey_key=163 and Current_master_varname in ('CSSSXXHV','CSSSIRHV','CBEDXXHV','CBEDIRHV','CWWHXXHV','CWWHIRHV','CDWHXXHV','CDWHIRHV','CCTUXXHV','CCTUIRHV','CCANXXHV','CCANIRHV','CCTPXXHV','CCTPIRHV','CPNTXXHV','CPNTIRHV','CCRNXXHV','CRICXXHV','CRICIRHV','CRYEXXHV','CRYEIRHV','CCRNIRHV','CSBSIRHV','CSBGXXHV','CSBGIRHV','CSWHXXHV','CSWHIRHV','COATXXHV','CSNOXXHV','CSNOIRHV','CSNNXXHV','CSNNIRHV','COATIRHV','CBARXXHV','CBARIRHV',
'CSRGXXHV','CSRGIRHV','CSOYXXHV','CSOYIRHV','CTOBXXHV','CTOBIRHV');
*%let Set=RB_survey_description='2021 DECEMBER AG SURVEY';
*%let Set=Edit_failure_flag=0;
*%let Set=Edit_failure_msg=NULL;
*%let Set=Edit_failure_msg='Reset for module 480 bug fix';
*%let Where=Survey_key=163 and State_poid in (6303789260,16301452000,16301021360,41300454800,41300549770,41300697220,16301333610
);
*%let Where=Survey_key=163 and State_poid in (23301153930,38300173540);
*%let Where=Survey_key=163 and Edit_failure_msg='Parked pending failover table update';
*%let Set=Other_item_code_flag=0;
*%let Set=Fips72_access_code='0';
*%let Set=Data_origin = 'NonReported';
*%let Set=Rb_survey_key=5099;
*%let Set=Tagged_code=NULL;
*%let Where=Survey_key not in (117,164) and User_id='smittr';
*%let Where =Survey_key in (123) and Data_origin='Calc by edit' and Numeric_code=.;
*%let Where=Master_varname in ('CGETDDFC');
*%let Where=Survey_key=164 and  Record_locked_flag =0 and State_poid in (72300019890,
72300021170,
72300021180,
72300021190,
72300022060,
72300023600,
72300034860,
72300039900,
72300042290,
72300044880,
72300048640,
72300050550,
72300050720,
72300051250,
72300056870,
72300057120,
72300057600,
72300061240,
72300061950,
72300086400,
72300086600,
72300110150,
72300129620,
72300133430,
72300186680,
72300188100,
72300190220,
72300190230,
72300216960,
72300218840,
72300219950,
72300220600,
72300223740,
72300241580,
72300257570,
72300265050,
72300266540,
72300273010,
72300277130,
72300281420,
72300286310,
72300302960,
72300303270,
72300313510,
72300317830,
72300349900,
72300352510,
72300355170,
72300358870,
72300367480,
72300375060,
72300376480,
72300380020,
72300382810,
72300388120,
72300389660,
72300391340,
72300392970,
72300395140,
72300397310,
72300400830,
72300404010,
72300408240,
72300412890,
72300446700,
72300459920,
72300461770,
72300461780,
72300477320);
*%let Set =Value=20000;

*%let Set=ELMO_src_year=NULL;
*%let Set=Reporting_county=51;

*%let Where=Survey_key=150 and Edit_name in ('TEMP30163','TEMP30363','TEMP30563','TEMP30963','TEMP31263','TEMP31463','TEMP31663','TEMP32063','TEMP32263','TEMP33063','TEMP33163','TEMP33363','TEMP33563','TEMP34063','TEMP34363','TEMP34563','TEMP34963','TEMP42463','TEMP43563','TEMP49263','TEMP52063','TEMP52463','TEMP53563','TEMP55063','TEMP62463','TEMP74863','TPCNT301','TPCNT303','TPCNT305','TPCNT309','TPCNT312','TPCNT314','TPCNT316','TPCNT320','TPCNT322','TPCNT330','TPCNT331','TPCNT333','TPCNT335','TPCNT340','TPCNT343','TPCNT345','TPCNT349','TPCNT424','TPCNT435','TPCNT492','TPCNT520','TPCNT524','TPCNT535','TPCNT550','TPCNT624','TPCNT748');
*%let Where =  Survey_key in (163,165) and Varname in ('CBBBCXAC','CBBXXCAC','CBBNCXAC');                         
*%let Where =  Survey_key=163 and State_poid in(5300013590);
*%let Where=Survey_key=163 and Item_code in (55,60);
*%let Where=Survey_key=152;
*%let Where=Survey_key=159;
*%let Where = Survey_key in (172,174) and  Current_status_code >=46  ;

*%let Where=Survey_key=145 and State_poid in (2300000100,2300004560,2300004650,2300007870,
2300012410,2300013560,2300019060,2300030100,2300040350,2300046270,2300080720,2300089310,2300095170,
2300095730,2300096000,2300097800,2300101570,2300101630,2300108470,2300108540,2300111610,2300118520,
2300119460,2300120370,2300121200,2300123300,2300127390,2300134980,2300040220,2300084300,2300116500) ;
/* Update dev db on SSB_DEV server */


/* MS PRISM DEV */


proc sql;
   connect to ODBC as HL (user=beraje password=&pw
             dsn=ms_prism3_dev  );

  execute  ( UPDATE &tablenam SET &set
                     where &where
                     ) by HL;
  disconnect from HL;
quit;
run;


/* MS PRISM */

/*
proc sql;
   connect to ODBC as HL (user=beraje password=&pw
             dsn=ms_prism3  );

  execute  ( UPDATE &tablenam SET &set
                     where &where 
                     ) by HL;
  disconnect from HL;
quit;
run;


*/
