
* Macro to load a Sybase table (when PROC DBLOAD not available)   */
/*******************************************************************\
| Copyright (C) 1997 by SAS Institute Inc., Cary, NC, USA.          |
|                                                                   |
| SAS (R) is a registered trademark of SAS Institute Inc.           |
|                                                                   |
| SAS Institute does not assume responsibility for the accuracy of  |
| any material presented in this file.                              |
\*******************************************************************/

/*******************************************************************/
/* Purpose: Build the SQL to create and load a table in a DBMS.    */
/*          This is useful when DBLOAD is not supported for the    */
/*          DBMS.                                                  */
/*******************************************************************/

/*
In case you want to debug the macro's,
uncomment this option statement right below: */
options nosymbolgen mprint nomlogic;

options source2;

/* Temporary file to store the data.                            */
/* We are using two for this code

    tmpbld  the actual create table code
    tmp     file that contains all the  execute insert commands

After the program runs, these files are left around in case
you would like to browse what was built.

Also make sure you assign a libname to the library where the dataset
you want to push into the DBMS is */

* filename tmpbld '/TECH0/sasasf/testdb2/tmp_create';
filename tmpbld 'c:\Windows\temp\tmp_create';
* filename tmpbld '/dev/null'; /* if you are not going to create a table */

filename tmp    'c:\Windows\temp\tmp_inserts2';
* filename tmp    '/TECH0/sasasf/testdb2/tmp_inserts';

libname  tmplib 'c:\Windows\temp';
* libname  tmplib '/TECH0/sasasf/testdb2';

 /* macro variables to provide an easy method for changing the   */
 /* desired information                                          */

%let table=System_info;
%let table=User_access;
*%let table=Code_description;
*%let table=Questionnaire;
*%let table=Questionnaire_section;
*%let table=Questionnaire_state;
*%let table=Module;
*%let table=Master_varname;
*%let table=Var_name;
%let table=Array_definition;
*%let table=Varname_section;
*%let table=Edit_name;
%let table=Edit_parm;
*%let table=Flag_definition;
*%let table=Flag_varname ; /* table name to use in DBMS _CASE SENSITIVE_ */
*%let table=DLT_definition;
*(%let table=DLT_rule;  /* table name to use in DBMS _CASE SENSITIVE_ */
*%let table=Categorical;
*%let table=Test_deck;
%let table=PRD_rule;

*%let table=PRD_rule_detail_item;

*%let table=Event_type;
*%let table=Survey;
*%let table=CATI_app;
*%let table=Survey_processing;
 %let libref=WORK;     /* libref of SAS DSET */
 %let dset=t&table;    /* SAS dataset you want to load into DBMS */
 %let format=12.4;      /* The format for sending over numeric data if the variable  */
                       /* doesn't already have a format associated with it          */

 %let dbms=sybase;

 %let drop=0;         /* set to 1 if you want to drop the table first    */
 %let create=0;       /* set to 1 if you want to create a table on dbms  */
                      /* if both drop and create are set to 0 the result */
                      /* is an append to an existing table               */

 %let cmit_frq=100;   /* The number of obs processed between commits     */

     /* Example of DB/2 or Ingres Connect String */
*%LET CNCT_STR= DATABASE='SAMPLE';

       /* Example of Sybase Connect String */
       
*%LET CNCT_STR= user='beraje' sybpw='Nevsky122018!' database='prismTrans' server=SSB_DEV ;
*%LET CNCT_STR= user='beraje' sybpw='Nevsky122018!' database='prism2' server=PRISM ;
*%LET CNCT_STR= user='beraje' sybpw='Nevsky052022!' database='prism3' server=PRISM ;
*LET CNCT_STR= user='beraje' sybpw='Nevsky052022!' database='prism3_dev' server=SSB_DEV ;

/* Loading to MS PRISM   */

%LET CNCT_STR= user='beraje' pw='Nevsky122023!' dsn=ms_prism3;
%LET CNCT_STR= user='beraje' pw='Nevsky122023!' dsn=ms_prism3_dev;
 %let dbms=ODBC;

/* Set up a view to the dictionary table "columns", this table contains */
  /* information about all sas datasets, set up the view to extract all   */
  /* information on the dataset we wish to load, for more information     */
  /* about dictionary tables, see "Technical Report P-222, Page 286       */

proc sql;
  create view vcolumn as
  select * from dictionary.columns
  where libname=upcase("&libref") and memname=upcase("&dset");
quit;
run;

  /*  The cre_tab macro, takes the information about the variables in the   */
  /*  dataset we are loading and uses that information to build the         */
  /*  create table statement that will be passed along to the database      */
  /*  The actual CREATE TABLE statement is written to the tmpbld fileref    */
  /*  defined on the filename statement above.                              */
  /*  The main function of the macro is to get the variable names and types */
  /*  on the create table statement.  It uses a combination of the variable */
  /*  type and format (in SAS) to arrive on the type value for the database */
%macro cre_tab;

  data _null_;
    %if &create %then
      %str(file tmpbld;);
    %else
      %str(file 'c:/Windows/temp/null';);
     /* %str(file '/windows/temp/null';);*/
    length vtype $ 80;

    /* now set the view, which has the following variables defined:
    /*     table DICTIONARY.COLUMNS
           LIBNAME char(8) label='Library Name',
           MEMNAME char(8) label='Member Name',
           MEMTYPE char(8) label='Member Type',
           NAME char(8) label='Column Name',
           TYPE char(4) label='Column Type',
           LENGTH num label='Column Length',
           NPOS num label='Column Position',
           VARNUM num label='Column Number in Table',
           LABEL char(40) label='Column Label',
           FORMAT char(16) label='Column Format',
           INFORMAT char(16) label='Column Informat',
           IDXUSAGE char(9) label='Column Index Type'        */
    /* The ones of particular interest are name, type and format   */

    set vcolumn  end=temp_var;

  /* first check to see if any of the variable names conflict with
  varnames that are used in this data step */

  if name = 'TEMP_VAR' | name = 'VTYPE' then
    do;
     put 'ERROR:  The variable name TEMP_VAR must be changed in this program.';
     put 'ERROR:  The variable name TEMP_VAR must be changed in this program.';
     put 'ERROR:  The variable name TEMP_VAR must be changed in this program.';
     put 'ERROR:  The variable name TEMP_VAR must be changed in this program.';
    end;

  /* since we have end=temp-var on the set statement, temp_var will be set to  */
  /* 1 when we are on the last observation in the dataset.  Since there is one */
  /* observation in this view for each variable in the dataset to be loaded    */
  /* when temp_var=1, then _n_ is the number of variables in the dataset to be */
  /* loaded.  So that value will be stored in the macro variable NOBS          */

  if temp_var then call symput('nobs',compress(put(_n_,5.)));

  /* now store the names of the variables in macro variables var1... varn */
  /* and store the variable format (which determines the type of data field     */
  /* since SAS only has CHAR and NUM, the format is used to identify date fields       */
  /* and the typnn macro vars are used to control the formats on the put statements    */
  /* that are used to actually write out the data to the flat file to be pushed        */
  /* into the DBMS                                                                     */
  /*************************************************************************************/
  /*                                                                                   */
  /* Bottom Line:  vtype is a datastep variable and is passed to the RDBMS on the      */
  /* create table statement.                                                           */
  /* &typnn is a macro variable is is used by the bldinst macro to control the formats */
  /* on the put statements the write out the values(....) clauses                      */

  call symput('var' || compress(put(_n_,5.)),name);
  call symput('fmt' || compress(put(_n_,5.)),format);


  if index(format,'DATETIME') then
    do;
      vtype=name || ' datetime null';    /* e.g., if name='mydate' then    */
                                         /* vtype = 'mydate datetime null' */

      call symput('typ' || compress(put(_n_,5.)),'DATETIME');
    end;
  else if index(format,'DATE')
        | index(format,'DDMMYY')
        | index(format,'MMDDYY')
        | index(format,'WORDDAT')
        | index(format,'YYMMDD') then
    do;
      vtype=name || ' datetime null';
      call symput('typ' || compress(put(_n_,5.)),'DATE');
    end;

  /* if the format is type Dollar, Sybase won't take the commas, so capture    */
  /* the length and decimals in the &len variable and save it so you can write */
  /* it out with a regular numeric format on the put statements in the bldinst */
  /* macro                                                                     */

  else if index(format,'DOLLAR') then
    do;
      vtype=name || ' money null';
      call symput('typ' || compress(put(_n_,5.)),'DOLLAR');
      call symput('len' || compress(put(_n_,5.)),substr(format,7) );
    end;

  else if type='num' then
    do;
      vtype=name || ' double precision null';
      call symput('typ' || compress(put(_n_,7.)),'FLOAT');
    end;

  else
    do;
      vtype=name || ' CHAR' || '(' || compress(put(length,9.)) || ') null';
      call symput('typ' || compress(put(_n_,5.)),'CHAR');
    end;

  /*  if it's the first observation, then write out the "PROC SQL; DROP TABLE
      and CREATE TABLE STATEMENTS  */

  if _n_ =1 then do;
    put "proc sql; connect to &dbms (&cnct_str);";

    %if &drop %then
       %str(put "execute(drop table &table ) by &dbms;";); /* drop the table first */
    %str(put "execute(create table &table (";);
  end;


  /* now we should have one observation for each variable to define on the table */
  /* so here is where we write out the variable name and definition that we put  */
  /* together above.  The idea is to end up with something that looks like:      */
  /*******************************************************************************
   proc sql; connect to sybase (user='sasasf' sybpw='sasasf' database='users');
   execute(drop table sam ) by sybase;
   execute(create table sam (
   STYLE    CHAR(8) null ,
   SQFEET   double precision null ,
   BEDROOMS double precision null ,
   BATHS    double precision null ,
   STREET   CHAR(16) null ,
   PRICE    double precision null ,
   MYDATET  datetime null )) by sybase;
   quit;
  ********************************************************************************/


  put vtype @@;

  if ~temp_var then
    put ',';
  else
    do;
      put ")) by &dbms;";
      put 'quit;';
    end;

  run;

  /* %INCLUDE the file generated above.  This will execute the code */
  /* that creates the table and check the return code
       */

  %if &create %then
    %do;
      %include tmpbld;
      %put proc sql return code:  &sqlxrc;
      %if &sqlxrc > 0 %then %put proc SQL message:  &sqlxmsg;
    %end;

%mend;




/* now the macro is defined so call it  */

%cre_tab;



/*----------------------------------------------------------------*/
/* Now, we should have a table on the database side that we can   */
/* now start to insert values into the table.                     */
/*----------------------------------------------------------------*/

  %macro bldinst;
    data _null_;
      file tmp;
      if _n_=1 then put 'proc sql;' /
                        "connect to &dbms (&cnct_str);" ;
      length tmpvar2 $ 18;
      set &libref..&dset end=temp_var;
      put  %str("execute (insert into &table values(");

      /* the following code uses put statements to write the values to
         the file in the form of execute insert values(...) statements
         but we need to vary the format according to each variable     */

      %do i=1 %to &nobs;
         %if &&typ&i = DATETIME %then
          %do;
            if &&var&i = . then
              put  'NULL' @;
            else
              do;
                tmpvar2 = compress( put(datepart(&&var&i.), mmddyy10.) ) || ' ' ||
                          compress( put(timepart(&&var&i.), time8.) );
                put "'" tmpvar2 $char22. "'" @;
              end;
          %end;
         %else %if &&typ&i = DATE %then
          %do;
            if &&var&i = . then
              put  'NULL' @;
            else
              do;
                tmpvar2 = compress(put(datepart(&&var&i.), mmddyy10.));
                put "'" tmpvar2 $char22. "'" @;
              end;
          %end;

         %else %if &&typ&i = DOLLAR %then
           %do;
              %let formatt = &&len&i;   /*  use the width and decimal portion of the    */
                                        /*  DOLLARW.D format, but take the DOLLAR       */
              if &&var&i = . then       /*  part off since commas are illegal in sybase */
                put  'NULL' @;
              else
                %str(put  &&var&i. &formatt @;);
           %end;

         %else %if &&typ&i = FLOAT %then
           %do;
             %if &&fmt&i = %then         /*  if the format for var is blank use the  */
                %let formatt= &format;   /*  default format stored in &format in the */
             %else                       /*  &format macro variable else use the     */
                %let formatt = &&fmt&i;  /*  format associated with the variable in  */
                                         /*  original dataset                        */
              if &&var&i = . then
                put  'NULL' @;
              else
                %str(put  &&var&i. &formatt @;);
           %end;

         %else %if &&typ&i = CHAR %then
           %do;
             if &&var&i = ' ' then
               put  'NULL' @;
             else
               %str(put "'" &&var&i. @+(-1)"'" @;);
           %end;

         %else
           %put Error:  No type for variable &&var&i;

         %if &i ^= &nobs %then %do;
           %str(put ',' @;);
         %end;
      %end;
      put ")) by &dbms;";

  /* Now check to see how many obs have been processed and if we are on
     the commit frequency one, then issue a commit statement*/

/*
    if mod(_n_,&cmit_frq) = 0 | temp_var then put "execute (commit) by &dbms;";
*/
      if temp_var then put 'quit;';

    run;

    /* %INCLUDE the file that contains the SQL generated above.  This */
    /* execute the code and load the table.                           */
    %include tmp;

    %put PROC SQL Return Code:  &sqlxrc;
    %if &sqlxrc > 0 %then %put Message from PROC SQL: &sqlxmsg;
  %mend;

  %bldinst;
