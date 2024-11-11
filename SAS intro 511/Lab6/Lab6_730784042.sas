proc printto log='/home/u63982087/BIOS511/Logs/lab6_73XXXXXX.log' new;run;

/********************************************************************************
   Project: BIOS 511

   Program Name: Lab6
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.09.09
   
   Purpose : This program is designed to practice proc means and proc univariate
*********************************************************************************/
%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;  
 
 
libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/


/* Question 1*/ 

proc means data = classlib.primary_biliary_cirrhosis std median mode nmiss lclm p25;
    title "Six Statistics Summary for Numeric Variables";
run;  /* 6 statistics for all numeric variables*/
     

/* Question 2*/

proc means data = classlib.diabetes n sum mean; /* generate count sum and mean for waist&hip*/
   class frame; /* generate the result by frame*/
   var waist hip;/* only display waist and hip*/
   title "Statistical Table for Waist & Hip by Frame";
run;

   
/* Question 3*/ 

proc means data = sashelp.orsales noprint nway;/*suppress printout & only display highest_type_value*/

   where year = 2002; /* use data where year = 2002*/
  
   class product_line product_category; /*generate stats by comb of theses two variables*/
   var quantity profit total_retail_price;/*display these three variables*/
  
   output out = stats_sum sum = /autoname;/*make an output dataset named 'stats_sum', and 
                                          the variables' name are automatically given*/
run;
   
/* Question 4 */

proc print data = work.stats_sum noobs; /*use the newly generated dataset from Q3
                                         without displaying obs number*/
                                        
   where product_line = 'Sports';/*use the data where product_line is sports*/
  
   format profit_sum dollar12.2; /*change the format of profit_sum*/
   var product_line product_category profit_sum; /*only display these three variables*/
  
   title "Profit Sum of Sports Product line";
run;


/* Question 5 */

proc means data = sashelp.orsales noprint nway; /*suppress printout & only display highest_type_value*/

   where year = 2002;    /* use data where year = 2002*/
  
   class product_line product_category;/*generate stats by comb of theses two variables*/
   var quantity profit total_retail_price;/*display these three variables*/
   
   output out = my_stats_sum /* create another dataset named 'my_states_sum'*/
  
   sum(profit total_retail_price) = sum_profit sum_retail /* sum of profit and trp and rename them*/
   mean(profit total_retail_price) = mean_profit mean_retail; /*mean of profit &trp and rename them*/
run;


/* Question 6*/

proc sort data = classlib.diabetes out = work.dibs; /* sort dataset by gender*/
     by gender;
run;

proc univariate data = work.dibs cibasic; /*generate the confidence limit by gender */
    by gender;
    var stab_glu; /*only display stab_glu and use it as the analysis variable*/
    title "Confidence Limits Tables of Stabilized Glucose by Gender";
run;
  
  
/* Question 7*/

proc univariate data = classlib.diabetes noprint ; /*suppress output*/
    class gender; /*sort data by gender*/
   
    histogram chol;/* make hisogram for cholesterol*/
    inset mean std/ pos = ne; /*inset description(mean & sd) to
                              the hisogram on the northeast corner*/
    
    title "Histograms for Cholesterol by Gender";
run;

proc printto; run;
