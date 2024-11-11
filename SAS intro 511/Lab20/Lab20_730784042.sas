
proc printto log='/home/u63982087/BIOS511/Logs/lab20_730784042.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab20
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.11.06
   
   Purpose : This program is a practice of DATA Step Statements
**************************************************************************************/


%put %upcase(no)TE: Program being run by 730784042;
options nofullstimer;


libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab20_730784042.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/
proc sort data = classlib.budget out = budget;
by region; /*sort budget dataset by region*/
run;


proc transpose data = budget 
               out = trans_budget(rename = (_name_ = year));
               /*transpose data to obs, rename the newvariable*/
  by region; /*sort data by region*/
  ID department;/* obs became variable name*/
  var yr20: ;/*name the variables whose value was transposed*/
run;


/***** Question 2 *****/
proc print data = trans_budget;
  where region = 3; /*subset to obs where region =3*/
  title "Q2: Budget Table Of Region 3";
run;



/***** Question 3 *****/
proc sort data = sashelp.stocks out = stocks;
 by date;/*sort stocks by date*/
run;

proc transpose data = stocks 
               out = trans_stocks(drop = _name_);
               /*transpose stocks data and drop the new variable _nanem_*/
    by date; /*sort by date*/
    ID stock;/*transpose each stock as new var*/
    var close;/*name the var whose value was transposed*/
run;
    
/***** Question 4 *****/
proc sgplot data = trans_stocks;/*apply sgplot*/
 series x=date  y=intel; /*make series plot with date as x-axis and intel as y-axis*/
 title "Q4:  Closing Value of Intel Stock Over Time";
run;


/***** Question 5 *****/

Data q5_budget; /*create new dataset from budget*/
 set classlib.budget;
 where department = "B";/*subset to department = B*/
 
 array years{5} yr2016 - yr2020; /*create a array of years with 5 elements*/
 
 do i = 1 to 5; /*loop to hold year and budget variable*/
 year = 2015 + i;
 budget = years{i};
 
 
 format budget dollar10.;/*apply new format*/
 
 keep region qtr year budget; /*only keep these variabels*/
 
        label /*apply labels*/
              region = "Region" 
              qtr = "Quarter"
              year = "Year"
              budget= "Budget Value";
        output;
    end;

    drop i department yr2016-yr2020;/*drop vars*/
run;
 

/***** Question 6*****/
ods select Variables; /*only select the variables table*/
proc contents data = q5_budget; /*conduct proc contents*/
 title "Q6: Variables Table from Q5 Budget Dataset";
run;


ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;

 




