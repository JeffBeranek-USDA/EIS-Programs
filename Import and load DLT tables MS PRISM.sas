

/*****************************************************************************/
/* Purpose: Build the SQL to import and load the DLT_definition and DLT_rule */
/*          tables to either prism3_dev or prism3.                           */
/*                                                                           */
/* Input:   Excel file DLT Load Generated File.xlsx created by Sanyou's      */
/*          DLT_load utility. File should be named                           */
/*          DLT Load Generated File.xlsx and located in                      */
/*          H:\Shared\MDSEIMB\EIS\CES\DLT_LOAD\                              */
/*                                                                           */
/* Output:  SAS datasets tDLT_definition and tDLT_rule to load to            */
/*          ms_prism3_dev or ms_prism3 DLT_definition and DLT_rule tables.   */
/*                                                                           */
/* Created: 6/17/2016                                                        */
/*                                                                           */
/* Last Updated: 11/04/2021 for MS_PRISM.JMB                                 */
/*                                                                           */
/* Author:  Jeff Beranek using code provided by Thomas Jacob.                */
/*****************************************************************************/

/*****************************************************************************/
/* 1) Specify DEV=Y if tables are to be loaded to ms_prism3_dev.             */
/*    Specify DEV=N if tables are to be loaded to ms_prism3.                 */
/*****************************************************************************/

/*****************************************************************************/
/* 2) Specify PRISM user id and password. Tick marks are important.          */
/*    Example:  uid  ='userid'                                               */
/*              pw='password'                                                */
/*****************************************************************************/


/******* End of User Input ***************************************************/

%let DEV=;
%let uid=;
%let pw=;

%window info

  #5 @5 'Do you want to load DLTs to DEV? (Y for DEV and N for Prod):'
  #5 @66 DEV 1 attr=underline
  #7 @5 'Please enter ms_prism3_dev/ms_prism3 userid:'
  #7 @49 uid 6 attr=underline
  #9 @5 'Please enter ms_prism3_dev/ms_prism3 password:'
  #9 @51 pw 20 attr=underline display=no
  #11 @5 'Please press ENTER when done';

* Display window contents;
%display info;
/*Macro connect creates the db connect string to log into ms_prism3_dev/ms_prism3. */

%macro connect;
%global CNCT_STR;

%if %UPCASE(&dev)=Y %then %do;
 %LET CNCT_STR= user='&uid' pw=&pw dsn='ms_prism3_dev' ;
%end;
%else %do;
 %LET CNCT_STR= user='&uid' pw=&pw dsn='ms_prism3';
%end;
%put &CNCT_STR=;
%mend connect;

%connect

/* Import the DLT_definition and DLT_rule tables from the DLT_load output file */

PROC IMPORT OUT= WORK.tDLT_definition
            DATAFILE= "H:\Shared\MDSEIMB\EIS\EIS Apps\DLT_LOAD\DLT Load Generated File.xlsx"
            DBMS=EXCEL REPLACE;
     RANGE="DLT_definition$";
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

PROC IMPORT OUT= WORK.tDLT_rule
            DATAFILE= "H:\Shared\MDSEIMB\EIS\EIS Apps\DLT_LOAD\DLT Load Generated File.xlsx"
            DBMS=EXCEL REPLACE;
     RANGE="DLT_rule$";
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


/*****************************************************************************/
/* Run program 'load to ms_prism.sas' successively for DLT_definition and    */
/* DLT _rule tables.                                                         */
/*****************************************************************************/

%let table=DLT_definition;

%include 'H:\Shared\MDSEIMB\EIS\CES\SAS Programs\load to ms_prism.sas';

%let table=DLT_rule;  
%include 'H:\Shared\MDSEIMB\EIS\CES\SAS Programs\load to ms_prism.sas';

