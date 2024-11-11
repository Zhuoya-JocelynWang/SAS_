proc printto log='/home/u63982087/BIOS511/Logs/lab16_730784042.log' new;run;


/************************************************************************************
   Project: BIOS 511

   Program Name: Lab16
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.23
   
   Purpose : This program is a practice of SAS-supplied formats
**************************************************************************************/
%put %upcase(no)TE: Program being run by 730784042;
options nofullstimer;



libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab16_730784042.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/
proc format; /*creat format of numetic variable*/
  value yn /*name variable*/
  0 = "No"
  1 = "Yes";/*apply values*/
run;


/***** Question 2 *****/
proc format fmtlib;/*creat format of numetic variable*/
    value marital_value /*name the variable*/
    1 = "Single"
    2 = "Married"
    3 = "Spearated"
    4 = "Divorced"
    5 = "Widowed";/* apply numeric value to each cat*/
   title "Q2: Format Contents of Variable";
run;


/***** Question 3 *****/
proc sgplot data = classlib.depression; /*apply plots*/
  format marital marital_value. acuteillness yn.; /*apply variables to marital and acuteillness*/
  vbar marital / group = acuteillness 
                seglabel ;/*create vertical barplot, 
                                          group by acuteillness, 
                                       label the frequency of each segment*/
  keylegend /position = topright 
            location = inside across=1
            title = "Response"; /* asjust legent position and title*/
  title "Q3: Vertical Barplot of Marital Status";
run;
 
 
/***** Question 4 *****/
data temp_dm;
  set classlib.dm;
  informed_var = input(rficdtc, yymmdd10.);/*new variable from rficdtc with dateformat*/
  first_treat = input(rfxstdtc, yymmdd10.);/*new variable from rfxstdtc with dateformat*/
  last_treat = input(rfxendtc, yymmdd10.);/*new variable from rfxendtc with dateformat*/
  days_1st_infom = first_treat - informed_var;/*difference between 1st and inform data*/
  days_last_1st = last_treat - first_treat;/* difference between last and first study treatment*/
run;


/***** Question 5 *****/
proc means data = temp_dm; /*apply proc means*/
  class sex race; /*class data by sex and race*/
  var days_1st_infom days_last_1st;/*only include the two variables*/
  title " Q5: Table of Days Difference by Sex and Race";
run;


/***** Question 6 *****/
proc freq data = classlib.primary_biliary_cirrhosis noprint; /* apply proc freq to 
                                      the dataset without output print*/
  tables drug*status/ out = data_q6; /*combination of drug and status
run; 
  
  
/***** Question 7 *****/
data q7_data; /*create newset based on data_q6*/
  set data_q6; 
  length cha_var $15; /*create a character variable with length 15*/
  cha_var = put(percent, 8.2)||'%'; /*new var contains & and 2 decimal*/
  label cha_var = "Character variable of percent"; /*label it*/
run;
  

/***** Question 8 *****/ 
proc print data = q7_data (obs =10) label; /*print the 1st 10 obs of q7_data with label*/
  var drug status cha_var;/*only show these variables*/
  title "Q8: Observations of Drug Status and Cha_var";
run;
  

ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;
  
  