proc printto log='/home/u63982087/BIOS511/Logs/lab10_73XXXXXX.log' new;run;


/************************************************************************************
   Project: BIOS 511

   Program Name: Lab10
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.09.30
   
   Purpose : This program is a practice of multiple type of Proc SGPlots
**************************************************************************************/

%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;  
 


libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/


ods pdf file = '/home/u63982087/BIOS511/Output/lab10_73XXXXXX.pdf' startpage = yes;
/* create a pdf file */


/***** Question 1 *****/

proc sgplot data = classlib.depression;
  hbar education/ response = beddays 
                  stat = mean 
                  dataskin = gloss;/*create horizontal bar, education is categrorical
                  variable, beddays is response variable, request mean, and change skin type*/
                  
  title "Barplot of Beddays by Education Level";
  xaxis label = "Mean Bed Days";/*name xaxis*/
run;


/***** Question 2 *****/

proc sgplot data = sashelp.cars;
  vbar type/ response = msrp stat =sum transparency = .3; 
  vbar type/ response = invoice stat = sum transparency =.3 barwidth=.5;
  
  /*2 vertical bar plotsof type, differnt response varibale, sum of invoce, msrp, 
  adjust the transparency of bar plot, and adjust with barwidth*/
  
  yaxis label = "MSPR & Invoice";/*Change yaxis name*/
  title "Overlaid Vertical Barplot of MSRP and Invoice by Type ";
run;
  

/***** Question 3 *****/
proc means data = classlib.vs noprint nway;/*suppress the printing of any output*/
   class vstestcd vstest visitnum visit;/*class the data by these variables*/
   var vsstresn;/*vsstresn is the analysed variable*/
   output out = my_vs mean = vs_mean; /*output the mean statitics*/
run;

/***** Question 4 *****/
proc sgplot data = my_vs noautolegend; /*plot the data without legend*/
   where vstestcd = "HR";/*only use the data where vstestcd = HR*/
   series x = visit y= vs_mean; /*series plot where x is visit and y is mean*/
   scatter x =visit y = vs_mean/markerattrs=(symbol = star);/*overlay scatter plot with 
                                                        visit variable, and the mean on y,
                                                        change the dot to star*/
   yaxis values = (59.9 to 60.4 by .05) label ="Heart Rate";/*adjust scale of yaxis, and change the label*/
   title "Mean Heart Rate by Visit ";
run;


ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;
