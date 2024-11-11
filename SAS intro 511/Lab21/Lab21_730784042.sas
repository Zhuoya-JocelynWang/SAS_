proc printto log='/home/u63982087/BIOS511/Logs/lab21_73XXXXXX.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab21
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.11.11
   
   Purpose : This program is a practice of Data Transpose
**************************************************************************************/

%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;


libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab21_73XXXXXX.pdf' startpage = yes;
/* create a pdf file */

/***** Question 1 *****/
proc sort data = classlib.ae out = ae;
   by AESOC AETERM; /*sort data*/
run;

Data q1_data;
  set ae;/*create new dataset from ae*/
  by AESOC AETERM;
  
  array severity_level{3} mild moderate severe; /*create three variables*/
  retain  mild moderate severe; /*retain the three variables*/
  
  if first.aeterm then do;/*only keep the first aeterm*/
     mild = 0;
     moderate = 0;
     severe = 0;
  end;/*set original value*/
  
  if aesev = "MILD" then mild +1; /* compute the value of the variable mild based on aesev*/
  else if aesev = "MODERATE" then moderate +1;/*compute moderate based on aesev*/
  else if aesev = "SEVERE" then severe +1;/*compute severe based on aesev*/
  
  if last.aeterm then output;/*mark last aeterm for output*/
  keep aeterm aesoc mild moderate severe;/*only keep these vars*/
run;
  

/***** Question 2 *****/
proc print data = q1_data; /*print the observation of subset 
                                    where aeterm is Jaw Tightness*/
  where aeterm = "Jaw Tightness";
  title "Q2: Count of Severity for AE Term of Jaw Tightness";
run;


/***** Question 3 *****/
proc sort data = classlib.lb out = lb;
  by USUBJID VISITNUM VISIT; /*sort data*/
run;

data q3_data;
  set lb; /*create new from lb dataset*/
  by USUBJID VISITNUM VISIT; 
  
  retain ALB CA HCT;/*retain the three varaibles*/
  
  if lbtestcd = "ALB" then ALB = lbstresn; /*Apply value of lbstresn for ALB variable
                                               when lbtestcd is ALB*/ 
  else if lbtestcd = "CA" then CA = lbstresn; /*Apply value of lbstresn for CA variable
                                               when lbtestcd is CA*/ 
  
  
  else if lbtestcd = "HCT" then HCT = lbstresn;/*Apply value of lbstresn for HCT variable
                                               when lbtestcd is HCT*/ 
  
  if Last.VISITNUM then output; /*mark the last visitnum for output*/
  
  keep USUBJID VISITNUM VISIT ALB CA HCT; /*keep these variables*/
run;

  
/***** Question 4 *****/ 
proc print data = q3_data;
 where usubjid = "ECHO-016-008"; /*print the result for subject ECHO-016-008*/ 
 title "Q4:Data Summary for Subject with ID ECHO-016-008";
run;

/***** Question 5 *****/ 
data q5_data;
  set classlib.TUMOR1; /*create new from tumor1 data*/
  
  output; /*output the orginal obs*/
  trt = "Z"; /*create a new obs =Z for each trt obs*/
  output;/*output the result*/
run;

/***** Question 6 *****/ 
proc freq data = q5_data;
  tables trt*gender; /*compute the table of treatment by gender*/
  title "Q6: Table of Number of patients for Each Treatment by Gender";
run;



ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;

 
