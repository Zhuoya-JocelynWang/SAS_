proc printto log='/home/u63982087/BIOS511/Logs/lab15_73XXXXXX.log' new;run;


/************************************************************************************
   Project: BIOS 511

   Program Name: Lab15
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.21
   
   Purpose : This program is a practice of conditionally executing statements
**************************************************************************************/

%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;


libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab15_73XXXXXX.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/
proc sort data = classlib.dm out = dm; by usubjid;
proc sort data = classlib.ae out = ae; by usubjid;
run;/* sort dm and ae dataset by usubjid*/

data q1_tempset; /*new dataset*/
   merge ae(in = inae) dm(in = indm);/*merge two dataset and assign indicators*/
   by usubjid;/*merge by usubjid variable*/
   if inae = 1 and indm = 0 then ad_event = 1;/*if the event onlyin ae data not in dm, --> had an event (=1)*/ 
   else ad_event = 0;/*otherwise indicator = 0 --> no event*/
   label ad_event = "Adverse Event Indicator";/*label the numeric indicator*/
run;



data q1_tempset; /*new dataset from q1_tempset and same name*/
   set q1_tempset;
   length Resulting_Category $50;/*set the length of new cat variable*/
   
   if aeser = "Y" then do;/*if serious = yes, do the condition and output*/
     
     if aeout = "NOT RECOVERED/NOT RESOLVED" 
      and aesev = "SEVERE" then Resulting_Category = "Very Bad"; 
      /*if output = "NOT RECOVERED/NOT RESOLVED" & severity = severe,
      the cat variable = verybad*/
      
      else if aesev = "MODERATE" or aesev = "MILD" then Resulting_Category = "Bad";
   end;/*other condition of output with severity = moderate or mild, cat cariable = bad*/
   
   
   else if aeser = "N" then do;/*if serious = NO, do the following condition & output*/
      
      if aeout = "NOT RECOVERED/NOT RESOLVED" 
      and aesev = "SEVERE" then Resulting_Category = "Not Good";
      /*if output = "NOT RECOVERED/NOT RESOLVED" & severity = severe,
      the cat variable = NOT GOOD*/
      
       
      else if aesev = "MODERATE" or aesev = "MILD" then Resulting_Category = "Acceptable";
   end;/*other condition of output with severity = moderate or mild, 
   cat cariable = Acceptable*/
   
   
   else if aeser = "" then Resulting_Category = "N/A";
   /*when serious is missing, then cat variable is N/A*/
   
   label Resulting_Category = "AE Character categorical Variable ";/*label the new vat variabel*/
    
run;
   

/***** Question 2 *****/
proc freq data = q1_tempset;/*apply proc freq to q1_tempset dataset*/
 table Resulting_Category;/*show the results*/
 title "Q1 Table of Resulting Category";
run;
  
  
  
/***** Question 3 *****/

proc sort data = classlib.dm out = dm; by usubjid;
proc sort data = classlib.ae out = ae; by usubjid;
run;/* sort dm and ae dataset by usubjid*/

data q3_tempset;/*new dataset*/
   merge ae(in = inae) dm(in = indm);/*merge two dataset and assign indicators*/
   by usubjid;/*merge by usubjid variable*/
  
   if inae = 1 and indm = 0 then q3_event = 1;/*if the event onlyin ae 
                                    data not in dm, --> had an event (=1)*/ 
   else q3_event = 0;/*otherwise indicator = 0 --> no event*/
   label q3_event = "Adverse Event Indicator";/*label the variable*/
run;



data q3_tempset;
   set q3_tempset;/*revise dataset on the original*/
   
   length Resulting_Category_q3 $50;/*set the length of new cat variable*/
    
   select;/*use selection  to execute condition*/
      when(aeser = "Y" and aeout = "NOT RECOVERED/NOT RESOLVED" and aesev = "SEVERE") do;
       
      Resulting_Category_q3 = "Very Bad"; /*when serious, output and sereverty
                                   meet the condition, new cat var is very bad*/
      
      end;
   
      when(aeser = "Y" and (aesev = "MODERATE" or aesev = "MILD")) do;                          
      Resulting_Category_q3 = "Bad";/*when serious, output and sereverty
                                   meet the condition, new cat var is bad*/
                
      end;
      
      when(aeser = "N" and aeout = "NOT RECOVERED/NOT RESOLVED" and aesev = "SEVERE")do;
      Resulting_Category_q3 = "Not Good"; /*when serious, output and sereverty
                                   meet the condition, new cat var is Not Good*/
      end;
      
      when(aeser = "N" and (aesev = "MODERATE" or aesev = "MILD")) do;
      Resulting_Category_q3 = "Acceptable" ;/*when serious, output and sereverty
                                   meet the condition, new cat var is Acceptable*/
      end;
      
      when(aeser = "") do; /*when serious is missing, new cat var is N/A*/
      Resulting_Category_q3 = "N/A" ;
      
      end;
      otherwise;/* other condition*/
    end;
    
   label Resulting_Category_q3 = "AE Character categorical Variable for q3";/*label the new variable*/
run;
        
 
 
/***** Question 4 *****/ 
proc compare base =  q1_tempset comp = q3_tempset; /* compare two datasets*/
title "Q4: Table for Two Datasets Comparison";
run;
   


/***** Question 5 *****/ 
data emp_don; /*new dataset from employee_donations*/
  set classlib.employee_donations;
  sum_fun = sum(of qtr1 - qtr4);/*sum by using sum fucntion*/
  sum_add = qtr1 + qtr2 + qtr3 + qtr4;/*sum by simply adding*/
  diff = sum_fun - sum_add;/*difference between the above two addition*/
run;
   
/***** Question 6 *****/   
proc means data = emp_don min max mean sum nmiss;/*apply these statistics to emp_don dataset*/
   var diff;/*only present diff variable*/
   title "Q6: Table for Sum Difference";
run;
   

/***** Question 7 *****/  
data temp_lm;/* create new dataset from leaning_modalities data*/
  set classlib.learn_modalities;
  week_part = datepart(week);/*extract date from the variables*/
  if week_part > "01JAN2021"d; /*subset the dataset with date > Jan 1st 2021*/
run;


/***** Question 8 *****/  
proc freq data = temp_lm; /*apply proc freq to temp_lm*/
  tables learning_modality; /*show the counts result*/
  title "Q8: Table For Learning Modality";
run;



ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;










