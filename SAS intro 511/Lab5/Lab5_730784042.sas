proc printto log='/home/u63982087/BIOS511/Logs/lab5_730784042.log' new;run;
/****************************************************************************
   Project: BIOS 511

   Program Name: Lab5
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.08.28
   
   Purpose : This program is designed to practice proc print and proc freq
*****************************************************************************/
  
%put %upcase(no)TE: Program being run by 730784042;
options nofullstimer;
 
 
/*Question 1*/

libname mylib '/home/u63982087/BIOS511/Data';/*access a libref in my personal folder*/ 
run;

proc sort data = sashelp.failure out = work.sas_fail; 
     
     by cause; /* sort data by 'cause' and store the it in temporary dataset*/
run;

title "Day & Count in Sashelp.failure Dataset by Cause "; /*add title of the output*/

proc print data = sas_fail; 
   
   by cause;  /*print by the variable 'cause'*/
   
   var day count; /*only print the 'dat' and 'count' variables*/
run;


/*Question 2*/

libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

proc print data = classlib.employee_donations noobs label; /* print this dataset with label name & without obs number*/ 
    
    options missing = 0; /* changing numeric missing value from . to 0*/
    
    label Paid_By = "Type_of_Payment"; /* label 'Paid_By' variable by "Type_of_Payment"*/
    
    format qtr: dollar8.2; /*change all quarter variables with dollar sign & 2 decimal places*/
    
    var paid_by recipients qtr:;/* print in this order*/
    
    sum qtr:; /* sum the values in each quarter variable*/
    
    title "Employee Donations in Dollars";/*add title of the output*/
run;


/*Question 3*/

title "Frequency Table of Gender";/*add title of the output*/

proc freq data = classlib.primary_biliary_cirrhosis;/*calculate the frequency of pbc dataset*/
   
   where drug ^= "not randomized";/* only for those subjects with treatments*/
   
   tables sex;/* only computing the table for sex variable*/
run;



/*Question 4*/

title "Table of Sex by Age";/*add title of the output*/

proc freq data = classlib.primary_biliary_cirrhosis;/*calculate the frequency of pbc dataset*/

    where drug ^= "not randomized" and age < 50;/* only use the data for the those subjects
                                                who are having treatmentand age < 50*/
                                               
    tables sex*stage;/*creating a crosstabulation of sex and age*/
run;
    

/*Question 5*/

title "Table of Customers Type by Group";/*add title of the output*/

proc freq data = classlib.customer_dim; /*calculate the frequency of cd dataset*/
   
   where customer_age > 50;/*only use the data with age >50*/
   
   tables Customer_Type * Customer_Group/list;/* create table in different order by customer 
                                               type & group in two statement*/
   tables Customer_Group * Customer_Type/list;
run; /*in these two statement, the option like was used to provide those 
     percent & cumulative values in list format*/


/*Question 6*/

title "Table of Treatment by Response";/*add title of the output*/

proc freq data = classlib.migraine;/*calculate the frequency of migraine dataset*/
    
    tables treatment*response/senspec; /*create a crosstabulation of treatment & response
                              variables and provide generate statistical table by SENSPEC*/
run;
     
proc printto; run;

