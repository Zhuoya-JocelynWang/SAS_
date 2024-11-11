proc printto log='/home/u63982087/BIOS511/Logs/lab13_73XXXXXX.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab13
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.09
   
   Purpose : This program is a practice of DATA Step Statements
**************************************************************************************/

%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;

libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab13_73XXXXXX.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/
data my_lb; /*tempporary version of lb dataset*/
set classlib.lb; /* data used in the following process*/
   
   where visit = "Week 32";/*only use the data where visit is Week 32*/
   lbcat = propcase(lbcat);/*first lettre is uppercase in lbcat variable*/
   
   length new_cvar $100; /*set length of new variable called new_car equals 100*/
   new_cvar = catx(": ", lbcat,lbtest);/*assign values to new variable with a lbcat: lbtest format*/

   keep usubjid visit lbstresn new_cvar;/*only keep these variables*/
run;


/***** Question 2 *****/
ods exclude enginehost;/*exclude enginehost from the output*/

proc contents data = my_lb;/* provide information about my_lb*/
title "Contents of Temporary lb Dataset";
run;

ods select all;/*reset ods to avoding affect the follwoing output*/


/***** Question 3 *****/
data my_lm;/*temp version of lm dataset*/
set classlib.learn_modalities (keep= district_name 
                              operational_schools student_count);
                              /*data used in the following process, and only
                              keep these variables*/
                              
  student_perschool = (student_count/operational_schools);/*calculate average
                                            number of students per operational school*/
  
  if student_perschool > 2000;/*use the data that student_perschool is greater than 2000*/
  
  label student_perschool = "Average number of students per 
                             operational school";/*label the new variable*/
                             
  drop operational_schools student_count;/*drop these two variables from my_lm*/
run;


/***** Question 4 *****/
proc sort data = my_lm out = temp_lm nodupkey;/* sort my_lm data, name output
                                              dataset as temp_lm, no replicates*/                                          
  
  by descending student_perschool district_name;/*sort data by descending order of
                                            these two variables*/
run;


/***** Question 5 *****/
proc print data = temp_lm (obs=25) label;/*print 25 obs of the dataset with variable Label*/
title" 25 Observation Sorted by Avg Num of Student Per School";
run;


/***** Question 6 *****/
data my_ed; /*temp dataset of employee_donations*/
set classlib.employee_donations;/*data used to compute the output in the tempdata*/
   total_donation = sum(of qtr1 - qtr4);/* new var = calculate the total donation of 4 quarters*/
   label total_donation =" Year's Total Donation For Each Employee";/*create label
                                                                   of the new variable*/
run;


/***** Question 7 *****/ 
ods noproctitle; /* suppress the procedure name*/
proc means data = my_ed n mean nonobs;/* apply proc mean, show sum and mean 
                                   of my_ed dataset, suppress the observation number*/
                                        
  class paid_by;/*generate statistics by paid_by variable*/
  var total_donation;/* analysis variable of proc mean procedure*/
  title "Sum and Mean of Year's Total Donation by Payment Type";
run;

/***** Question 8 *****/ 
proc freq data = sashelp.heart(rename = (chol_status = chol bp_status = bp));
                /* apply proc freq on the dataset, rename two variables*/
  
   tables chol*bp;/* create crosstabulation of the two variables*/
  
   title "Combination of Cholesterol Status & Blood Pressure Status";
run;
  

ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;


 


  
