
/** delete rows from a sybase table   **/


/*****************************************************************************/
/* Specify table name from which rows will be deleted, and the code to       */
/* specify which rows will be deleted.                                       */
/****************************************************************************/

%let pw='Nevsky122023!';
*%let tablenam=System_info;
*%let tablenam=PRD_rule_detail_item;
*%let tablenam=PRD_rule;
*%let tablenam=Var_name;
*%let tablenam=Varname_section;
*%let tablenam=Edit_parm;
*%let tablenam=Edit_name;
*%let tablenam=Master_varname;
*%let tablenam=Categorical;
*%let tablenam=DLT_rule;
*%let tablenam=Array_definition;
*%let tablenam=Test_deck;
%let tablenam=Flag_varname;
%let tablenam=Flag_definition;
*%let tablenam=User_access;
*%let tablenam=Array_definition;
*%let tablenam=Questionnaire_section;
*%let tablenam=Questionnaire_state;
*%let tablenam=Questionnaire;
*%let tablenam=Module;
*%let tablenam=Session;
*%let tablenam=Code_description;
*%let tablenam=Reservation;
*%let where=  User_id='smittr'; 
%let where= Survey_key in (173) and Module_number=130;
*%let where= Survey_key in (163,165) and Array_name='CROPNCDE';

/* MS PRISM DEV */


proc sql;
   connect to ODBC as HL (user=beraje password=&pw
             dsn=ms_prism3_dev  );

  execute  ( delete &tablenam
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

  execute  ( delete &tablenam
                     where &where
                     ) by HL;
  disconnect from HL;
quit;
run;


*/
/*
proc sql;
   connect to sybase as HL (user=beraje password=&pw
             server=SSB_DEV database=prism3_dev  schema='dbo');

  execute  ( delete &tablenam
                     where &where
                     ) by HL;
  disconnect from HL;
quit;
run;


proc sql;
   connect to sybase as HL (user=beraje password=&pw
             server=PRISM database=prism3  schema='dbo');

  execute  ( delete &tablenam
                     where &where
                     ) by HL;
  disconnect from HL;
quit;

run;
*/


/*
proc sql;
   connect to sybase as HL (user=beraje password=&pw
             server=prism database=prism2  schema='dbo');

  execute  ( delete &tablenam
                     where &where
                     ) by HL;
  disconnect from HL;
quit;

run;

*/

