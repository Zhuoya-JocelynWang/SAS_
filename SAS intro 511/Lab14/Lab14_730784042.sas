proc printto log='/home/u63982087/BIOS511/Logs/lab14_730784042.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab14
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.14
   
   Purpose : This program is a practice of DATA Step Statements
**************************************************************************************/

%put %upcase(no)TE: Program being run by 730784042;
options nofullstimer;

libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

libname mylib '/home/u63982087/BIOS511/Data';
/*accesse a libref that points to the Data foler under my own BIOS511 folder*/
run; 


ods pdf file = '/home/u63982087/BIOS511/Output/lab14_730784042.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/
proc sort data = classlib.dm out = dm; by usubjid;
proc sort data = classlib.ae out = ae; by usubjid;
run;
/* sort dm and ae dataset by usubjid*/

data mylib.aedm;/*permanent new data*/
  merge dm ae;/*merge the two dataset above*/
  by usubjid;/*by the variable usubjid*/
run;


/***** Question 2 *****/
ods exclude enginehost variables;/*exclude enginehost and var list from the output*/

proc contents data = mylib.aedm;/* provide information about my_lb*/
title "Q2 Table: Contents of Permanent AEDM Dataset";
run;

ods select all;/*reset ods to avoding affect the follwoing output*/


/***** Question 3 *****/

proc sort data = classlib.dm out = dm; by usubjid;
proc sort data = classlib.ae out = ae; by usubjid;
run;
/* sort dm and ae dataset by usubjid*/

data temp_aedm; /* create temporary dataset*/
  merge dm(in = ind) ae(in = ina);/*merge two data and make a indicator for two sets*/
  by usubjid;/* by variable usubjid*/
  if ind = 1 and ina =0; /* subject only in dm dataset not in ae set*/
  keep usubjid sex age;/* keep these three variables*/
run;


/***** Question 4 *****/
proc print data = temp_aedm (obs = 10);/*privide first 10 variables*/
title " Q4 Table: First 10 Obsercation of Temporary AEDM Dataset";
run;


/***** Question 5 *****/
proc sort data = classlib.dm out = dm; by usubjid;
proc sort data = classlib.ae out = ae; by usubjid;
run;
/* sort dm and ae dataset by usubjid*/

data mylib.aedm2;/*new permanent dataset called aedm2*/
  merge dm(in = ind) ae(in = ina);/*merge two data and make a indicator for two sets*/
  by usubjid;/* by variable usubjid*/
  if ind = 1 and ina =1; /* subject in both sets*/
run;


/***** Question 6 *****/
proc freq data = mylib.aedm2; /* proc freq show the counts*/
  tables arm*sex*aesev;/* show the table by the three variables*/
  title "Q6 Table: Crosstabulaion by Arm Sex and AESEV";
run;



/***** Question 7 *****/

proc sort data = classlib.vs out=vs;/*proc sort the vs dataset by the 3variables*/
 by usubjid visitnum visit;
run;


data ds_bp;/*create dataset called ds_bp*/
  set vs;/*use the data in vs dataset*/
  if vstest = "Diastolic Blood Pressure"; /* use the data where vstest = dbp */
  keep usubjid visitnum visit vsstresn;/* only keep these variables in the sets*/
  rename vsstresn = DIABP;/*rename vsstresn variable to DIABP*/
run;


data sy_bp;/*create dataset called sy_bp*/
 set vs;/*use the data from vs dataset*/
 if vstest = "Systolic Blood Pressure";/*use the data where vstest = sbp*/
 keep usubjid visitnum visit vsstresn;/* only keep these variables in the sets*/
 rename vsstresn = SYSBP;/*rename vsstresn variable to sysbp*/
run;
  

data temp_q7;/*create dataset*/
 merge ds_bp(in = inds) sy_bp(in = insy);/*merge the above two sets and make indicators*/
 if inds = 1 and insy =1;/*the dataset should keep both subjects*/
 by usubjid visitnum visit;/* by the three variables*/
run;

/***** Question 8 *****/
proc print data = temp_q7;
  title "Q8 Table: Observations for Subject ECHO-012-019";
  where usubjid = "ECHO-012-019";/*apply proc print to the new dataset,
                                provide the observations where usubjid is "ECHO-012-019"*/                                 
run;


/***** Question 9 *****/
data temp_q9;/*new dataset*/
   merge /*merge two vs with different data by different vstest and 
          rename the bp variable*/     
   vs(where = (vstest = "Diastolic Blood Pressure") rename=(vsstresn = DIABP))
   vs(where = (vstest = "Systolic Blood Pressure") rename=(vsstresn = SYSBP));
   
   keep usubjid visitnum visit DIABP SYSBP;/*keep these variables*/
run;



/***** Question 10 *****/
ods exclude enginehost;/* exclude enginehost table from the output*/
proc contents data = temp_q9;/* show the content of the dataset in Q9*/
title "Content Table For Q10";
run; 
ods select all;/*reset ods to avoding affect the follwoing output*/



ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;

