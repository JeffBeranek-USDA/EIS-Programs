  %let password='Nevsky102023!';

 * libname prism3d  sybase  server=SSB_DEV database=prism3_dev
                          user=beraje schema='dbo' password=&password;		

libname prism3d  ODBC  dsn=ms_prism3_dev user=beraje  password=&password;		

libname prism3p  ODBC  dsn=ms_prism3 user=beraje  password=&password;


%let tablenam=Varname_section;

data t&tablenam;
 set prism3d.&tablenam(where =(Survey_key=172 and Item_code=9919  )); 
run;
%let tablenam=Var_name;

data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=166 )); 
Survey_key=175;
run;

%let tablenam=Module;

data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=166 )); 
Survey_key=175;
run;

%let tablenam=Categorical;
data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=166 )); 
Survey_key=175;
run;

%let tablenam=Questionnaire_section;

data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=166 )); 
Survey_key=175;
run;

%let tablenam=Questionnaire;

data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=166 )); 
Survey_key=175;
run;

%let tablenam=Questionnaire_state;

data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=166 )); 
Survey_key=175;
run;

%let tablenam=Edit_name;
data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=152 )); 
 Survey_key=166;
run;

%let tablenam=Edit_parm;
data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=152 )); 
 Survey_key=166;
run;
%let tablenam=Flag_definition;
data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=163 and Module_number=20 and Flag_number=1 )); 
 Survey_key=165;
run;
%let tablenam=Flag_varname;
data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=163 and Module_number=20 and Flag_number=1 )); 
 Survey_key=165;
			    
run;
%let tablenam=DLT_definition;
data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=163 and Module_number=20 and Document_number=1 )); 
 Document_number=1;
 Survey_key=165;
 run;
%let tablenam=DLT_rule;
data t&tablenam;
 set prism3d.&tablenam(where =(Survey_key=163 and Module_number=405)); 

run;
%let tablenam=Array_definition;
data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key in(163) and Array_name in ('LVSKPRDV','LVSKCURV'))); 
 Survey_key=165;run;
/*
%let tablenam=Master_varname;
data t&tablenam;
 set prism3d.&tablenam(
                       where=( Master_varname in ('MDCXTLVC','MDINTLVC','MDITTLVC','MDRXTLVC'))); 
run;
*/
%let tablenam=Test_deck;
data t&tablenam;
 set prism3d.&tablenam( where =(Survey_key=138 and Module_number in (20,770,771,775))); 
 Survey_key=159;

run;



%let tablenam=PRD_rule;

data t&tablenam;
 set prism3p.&tablenam(
                       where=( Survey_key= 166)
                       );
					    Survey_key=175;
run;
%let tablenam=PRD_rule_detail_item;

data t&tablenam;
 set prism3p.&tablenam(
                       where=( Survey_key= 166)
                       );
					    Survey_key=175;
					    
run;
*/
%let tablenam=System_info;

data t&tablenam;
 set prism3d.&tablenam(where =(Survey_key=146)); 
 Survey_key=153;
					    
run;
%let tablenam=User_access;

data t&tablenam;
 set prism3p.&tablenam(where =(Survey_key=163)); 
 Survey_key=168;if user_id in ('andeed','bailje','apodma') then delete;
					    
run;

/*
%let tablenam=Code_description;

data t&tablenam;
 set prism3p.&tablenam(
                       where=( Survey_key= 96)
                       );Survey_key=110;
					    
run;
%let tablenam=Code_description;

data t&tablenam;
 set prism3p.&tablenam(
                       where=( Survey_key= 96)
                       );Survey_key=110;
					    
run;
%let tablenam=CATI_app;

data t&tablenam;
 set prism3d.&tablenam(
                       where=( Survey_key= 134)
                       );Survey_key=143;
					    
run;
%let tablenam=Survey_processing;

data t&tablenam;
 set prism3d.&tablenam(
                       where=( Survey_key= 134)
                       );Survey_key=143;
					    
run;
*/
