
proc printto log='/home/u63982087/BIOS511/Logs/lab17_73XXXXXX.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab17
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.28
   
   Purpose : This program is a practice of DO-loops
**************************************************************************************/

%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;

libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab17_73XXXXXX.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/
Data Q1_dayset;/*create new temp dataset*/
  do date_obs = '01AUG2024'd TO '31DEC2024'd;/*range of date*/
     ran_day = rand('geometric', 0.2);/*apply geometric distribution 
                            with 0.2 to genereate random variable*/
     output;/*output*/
  end;
  
  format date_obs date9.;/*formate of date*/
run;
  
/***** Question 2 *****/
proc means data = Q1_dayset; /*apply proc means*/
  where month(date_obs) = 10;/*only use the date in October*/
  var ran_day;/* analysis on ran_day*/
  title "Q2: Table of Ran_Day with the Month of October";
run;


/***** Question 3 *****/
data tempq3_stocks;/* temp dataset from sashelp.stocks*/
  set sashelp.stocks;
  where date = '02Aug2004'd and stock = "IBM";/*subset to 02/08/2004 and IBM*/
  
  do i = 1 to 5;/*create 5obs*/
     adjclose = (adjclose + 0.04*adjclose);/*increase adjclose by 4% each year*/
     date = intnx('year', date, 1, "same");/*same date increase year*/
     output;
  end;
  keep stock date adjclose;/*only keep these three variables*/
run;

/***** Question 4 *****/
proc print data = tempq3_stocks;/*proc print the result table from last question*/
title "Q4: Five Observaton From Stocks Dataset";
run;


/***** Question 5 *****/
data q5_stocks;/* temp dataset from sashelp.stocks*/
  set sashelp.stocks;
  where date = '02Aug2004'd and stock = "IBM";/*subset to 02/08/2004 and IBM*/
  
  do until (adjclose > 300);/*stop until adjclose > 300*/
     adjclose = (adjclose + 0.04*adjclose);/*increase adjclose by 4% each year*/
     date = intnx('year', date, 1, "same");/*same date increase year*/
     output;
  end;
  keep stock date adjclose;/*only keep these three variables*/
run;


/***** Question 6 *****/
proc print data = q5_stocks; /*proc print last question*/
title "Q6: IBM Stocks with Adjclose > 300";
run;


/***** Question 7 *****/
data _null_; /*create null set from prosteate dataset*/
  set classlib.prostate;
  if 40 <= age <= 50 then putlog patientnumber =;/*compute patients
                                         number with age b/w 40 and 50*/
run;


ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;
