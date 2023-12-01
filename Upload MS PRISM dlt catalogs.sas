



+/*****************************************************************************/
/* Purpose: Upload compiled DLT catalogs to Unix using SAS9.2                */
/*                                                                           */
/* Input:   Via window, user must specify the following:                     */
/*                                                                           */
/*          1) Platform:  beta = development.                                */
/*                        prod = production.                                 */
/*                                                                           */
/*          2) PRISM survey_key                                              */
/*                                                                           */
/*          3) Database (prism3_dev/prism3) user_id and password.            */
/*                                                                           */
/*                                                                           */
/* Output:  None; loads complied SAS catalogs of DLTs and DLT parameter file */
/*          to prism unix box.                                               */
/*                                                                           */
/* Created: 6/21/2016                                                        */
/*                                                                           */
/* Last Updated: 6/15/2022 for MS_PRISM.  JMB                                */
/*                                                                           */
/* Author:  Jeff Beranek using code provided by Ai Linh Nguyen.              */
/*****************************************************************************/


/* Server log-in information */
* Clear macros - necessary if rerunning this prompt within the same SAS session;

%let platform= ;
%let survey_key= ;
%let id= ;
%let pass= ;

%window info

  #5 @5 'Please enter platform - beta (for development) or prod (for production):'
  #5 @78 platform 4 attr=underline
  #7 @5 'Please enter ms_prism3/ms_prism3_dev survey key:'
  #7 @54 survey_key 3 attr=underline
  #9 @5 'Please enter ms_prism3/ms_prism3_dev userid:'
  #9 @50 id 6 attr=underline

  #11 @5 'Please enter ms_prism3/ms_prism3_dev password:'
  #11 @52 pass 20 attr=underline display=no
  #13 @5 'Please press ENTER when done';

* Display window contents;
%display info;

libname prismLib odbc user="&id" pw="&pass" db=ms_prism3_dev;

data survey_data;
 set prismLib.Survey
                    (
                     where=(survey_key=%eval(&survey_key))
                     keep =Survey_key Survey_abbrev Survey_year Survey_month
                    );
 Yr=put(survey_year-2000,z2.);
 mo=put(Survey_month,z2.);
 call symput('s_string',lowcase(Survey_abbrev)||YR||mo);
 call symput('S_key',put(Survey_key,z4.));
run;

/* Clears the log and the output window */
/* If you do not want these cleared, do not run next two lines */
dm log 'clear' ;
dm output 'clear';
/* Need survey abbrev yy mm in 6 character string (aayymm); obtain from   */
/* prism3 or prism3_dev Survey table.                                     */


/******* End of User Input ***************************************************/

/* Login to prism unix box */

/*filename rlink 'm:\sas92\sasfoundation\9.2\connect\saslink\tcpunix.scr';  */  /*HoaiNam commented out*/

filename rlink 'M:\SAS94\SASFoundation\9.4\connect\saslink\tcpunix.scr';    /*HoaiNam updated on 11/16/2018*/

OPTIONS comamid=tcp remote=prism.4016;   
SIGNON prism.4016;


/* Define local (citrix) libnames for DLT catalogs */

options mprint mtrace;
%macro llibname;

%if %UPCASE(&platform)=BETA %then %do;

libname in "S:\Data_Files\prism3_mssql\System\&platform\&s_string\Edit" ;

%end;
%else %if %UPCASE(&platform)=PROD %then %do;
libname in "R:\Data_Files\prism3_mssql\System\&platform\&s_string\Edit" ;
%end;
%mend llibname;
%llibname


/* Define remote (unix) libnames for DLT catalogs */

%macro rlibname;
%syslput platform=&platform;
%syslput s_string=&s_string;
%syslput s_key=&s_key;


%if %UPCASE(&platform)=BETA %then %do;
rsubmit;
%put "/proj/prism3_mssql/system/&platform/&s_string/edit/";
  libname out "/proj/prism3_mssql/system/&platform/&s_string/edit/";
  
    proc upload incat=in.survey_&s_key outcat=out.survey_&s_key ;
    run;
  
    proc upload incat=in.survey_&s_key._params outcat=out.survey_&s_key._params ;
    run;
		/*HoaiNam adding this part to control which group of users have rwx*/
SYSTASK COMMAND "chmod 775 /proj/prism3_mssql/system/&platform/&s_string/edit/survey_&s_key..sas7bcat" wait status=attrfl; 
SYSTASK COMMAND "chmod 775 /proj/prism3_mssql/system/&platform/&s_string/edit/survey_&s_key._params.sas7bcat" wait status=attrfl; 

endrsubmit;
%end;
%else %if %UPCASE(&platform)=PROD %then %do;

rsubmit;
  libname out "/proj/prism3_mssql/system/&platform/&s_string/edit/";
  
    proc upload incat=in.survey_&s_key outcat=out.survey_&s_key ;
    run;
  
    proc upload incat=in.survey_&s_key._params outcat=out.survey_&s_key._params ;
    run;
	/*HoaiNam adding this part to control which group of users have rwx*/
SYSTASK COMMAND "chmod 775 /proj/prism3_mssql/system/&platform/&s_string/edit/survey_&s_key..sas7bcat" wait status=attrfl; 
SYSTASK COMMAND "chmod 775 /proj/prism3_mssql/system/&platform/&s_string/edit/survey_&s_key._params.sas7bcat" wait status=attrfl; 

endrsubmit;

%end;
%mend rlibname;

%rlibname

 
/* log off prism unix box */

SIGNOFF prism.4016;
