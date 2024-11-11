proc printto log='/home/u63982087/BIOS511/Logs/lab12_730784042.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab12
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.07
   
   Purpose : This program is a practice of DATAStep (generating new dataset& function
**************************************************************************************/

%put %upcase(no)TE: Program being run by 730784042;
options nofullstimer;


libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab12_730784042.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/
data work.data_us; /*temporary verstion of sashelp.us_data, and name it as data_us*/
set sashelp.us_data;/*use original data used is us_data in sashelp folder*/

percent_change = round(((population_1970 
                  - population_1960)/population_1960)*100, 0.01);
                  /*calculate the percent and round the result to two decimal*/
                

abs = abs(percent_change - change_1970);/*absolute value*/
total_seatchange = sum(seat_change_1910,seat_change_1920,seat_change_1930,seat_change_1940,seat_change_1950,
         seat_change_1960,seat_change_1970);/* calculate total seat change*/
run;

/***** Question 2 *****/
proc sort data = data_us  out = my_data_us;/*sort data_us and compute the result 
                                           in the dataset called my_data_us*/
   by descending percent_change;/*sort data_us by 
                                percent_change in a descending order*/
run;


/***** Question 3 *****/

proc print data = my_data_us (obs = 15) noobs;/*print the first 15 data in Q2, surpress observation number*/
   var statename division population_1960 population_1970 change_1970 
   percent_change abs total_seatchange;/*only show these variables in the output*/
   title"Table of First 15 Observations";
run;


/***** Question 4 *****/
data tem_budget;
set classlib.budget;  /*name temporary budget use the data
                        from budget in class folder*/

mean_budget = mean(of yr2016 - yr2020);/* average of 5 budget variables*/
min_budget = min(of yr2016 - yr2020);/*minimum of 5 budget variables*/
max_budget = max(of yr2016 - yr2020);/*maximum of 5 budget variabels*/
multiplier = 1.12;/*new variable name multiplier and equals to a constant value of 1.12*/
run;

/***** Question 5 *****/

ods noproctitle;
title "Table of Budget by Department";
proc means data = tem_budget mean min max nonobs ;/*print mean, min, and max of the target variables*/
 class department;
 var mean_budget min_budget max_budget multiplier;/*show these 4 variables in the output dataset*/
run;


/***** Question 6 *****/ 
data temp_diab; /*new dataset called temp_diab*/
set classlib.diabetes;/* data used to compute the result in temp_diab*/
 feet = int(height/12);/* calculate the height in feet and in integer*/
 remain_inch = (height - feet*12);/*remaing height in feets as integer*

/***** Question 7 *****/
proc sgplot data = temp_diab;
 vbar frame / response = feet stat = mean group = frame;
                       /*create a vertical barplot by frame, and y is mean value of feet,
                       each bar has different color*/
 title" Vertical Barplot of Height in Each Frame";
run;


ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;

