
proc printto log='/home/u63982087/BIOS511/Logs/lab18_73XXXXXX.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab18
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.30
   
   Purpose : This program is a practice of Arrays
**************************************************************************************/


%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;


libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab18_73XXXXXX.pdf' startpage = yes;
/* create a pdf file */



/***** Question 1 *****/
data temp_price; /* temp data from prices*/
  set classlib.prices;
  array profit(15) profit1 - profit15; /*create new profit variables*/
  array price(15) price1 - price15;/*define the price variables*/
  
  do i = 1 to dim(price);/*do the following loop from 1 to the dimension of price*/
    profit(i) = price(i) - discount; /*formula to calculate each profit*/
  end;
  format profit1 - profit15 dollar10.2;/*adjust the format of profit variables*/
  keep profit1 - profit15;/*only keep profits*/
run;
  





/***** Question 2 *****/
data q2_set;/*temp data from the dataset we created in last question*/
 set temp_price;
 length highest $35;/*create new variable called highest with length 35*/
 
 array profit(15) profit1 - profit15;/*define the profit variables*/
 hold_value=0;/*initial variable to a "hold" variable*/
 do i= 1 to dim(profit); /*do the loop from number of dimension of profit times*/
   if profit{i}> hold_value then do;
   hold_value = profit{i}; /*if ith profit is greater than hold value, replace it*/
   highest = vname(profit{i}); /*hold the name of the profit with highest value*/
   end;
 end;
 drop i;/*drop iterat*/
run;



/***** Question 3 *****/ 
proc freq data = q2_set;
  table highest; /*apply proc freq only to the variable highest*/
  title "Q3: Table of Distribution of the Variable 'Highest'By Race";
run;





/***** Question 4 *****/
data q4_temp; /*temp data from birthwgt*/
 set sashelp.birthwgt;
  array binary{*} $lowbirthwgt married /*create character variables*/
        drinking death smoking somecollege;
        
  array num_binary{*} num_lowbirthwgt num_married 
                      num_drinking 
                      num_death num_smoking
                      num_somecollege; /*create numeric variable*/
 
  do i=1 to dim(binary);/*do loop for 'number of the vairables in binary' times*/
    if binary{i} = "Yes" then num_binary{i}=1; /*if ith obs is Yes, 
                                              then ith numeric =1*/
                                             
    else num_binary{i} = 0;/*other ith numeric = 0 if fail to meet binary(i)=yes*/
  end;
  drop i; /*drop iterate number*/
run;






/***** Question 5 *****/
ods noproctitle;/*surpress procedure title*/
proc sort data = q4_temp;
 by race; /*sort the dataset by race*/
run;

ods select ChiSq;/*only show chisq tables*/
proc freq data = q4_temp;
  by race; /*apply proc freq to data and sort by race*/
 
  table num_lowbirthwgt*num_drinking/chisq;/*show the crosstabulation
                                      of the two variables and generate chisq*/
run;




/***** Question 6 *****/
data q6_data; /*create new temp dataset from heart*/
  set sashelp.heart;
  
  array character_var{*} _character_; /*define all character varaiable character_var*/
  array num{*} _numeric_;/*define all numeric varaiable num*/
 
  do i = 1 to dim(character_var); /*do the following for chacter variable*/
   character_var{i} = upcase(character_var{i});/*change the values to be all upper*/
  end;
  
  do j = 1 to dim(num);/*add 3% to all numeric variables*/
    if num{j} then num{j} = (num{j}+num{j}*0.03);
  end;
  
  if SEX = "MALE" and STATUS = "DEAD" and WEIGHT > 190; /*subset the data 
                                           that meet the three conditions*/
  
  drop i j;/*drop iterator variables*/ 
run;
  
  
   
  

/***** Question 7 *****/
proc print data = q6_data (obs =10);/*show firt 10 obs*/
 var weight BP_Status; /*only keep these two vairables*/
 title "Q7: First 10 Observation of Weight and BloodPressure_Status";
run;
  

ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;

