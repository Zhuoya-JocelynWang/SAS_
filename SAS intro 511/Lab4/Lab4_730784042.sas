proc printto log='/home/u63982087/BIOS511/Logs/lab4_73XXXXXX.log' new;run;
/* Project: BIOS 511

   Program Name: Lab4
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.08.28
   
   Purpose : This program is designed to practice proc sort and proc contents */
  
%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;
 

/* Question1 */
/*accesse a libref that points to the Data foler under u49231441 folder under the  my_shared_file_links folder*/
libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run;

proc sort data = classlib.customer_dim out = work.customer_dim;/*sort & store the customer dataset in temporary set*/
   by Customer_LastName;/*sort the dataset by LastName*/
run;


/* Question2 */

proc sort data = classlib.primary_biliary_cirrhosis out = work.pbc (keep= drug status spiders) nodupkey;/*present unique obs in the three variables*/
      by drug status spiders;/*sort by these 3 variabels &store in temporary dataset*/
run;

/* Question3 */

proc sort data = classlib.drivers out = work.drivers;/*sort & store drivers dataset*/
     by cohort; /*sort by variable 'cohort'*/
run;

/* Question4 */
libname mylib '/home/u63982087/BIOS511/Data';/*access a libref in my personal folder*/ 
run;

proc sort data = classlib.drivers out = mylib.drivers; /*store drivers in my personal set*/
    where state = 'North Carolina';/*only obs satifying state ='NC' will be used by the PROC*/
    by gender;/*sort these obs by gender*/
run;

/* Question5 */
title "Variable Name of Customer_Dim Dataset Ordered by Last Name "; /*title the output*/
proc contents data = work.customer_dim varnum; /*print the information of customer dataset, and print variables by previous order*/
run;


/* Question6 */
proc contents data = work.customer_dim out = work.temp_cdsup NOPRINT;/*print & store the contents in temporary dataset & suppress the outpus*/
run;

proc printto; run;

