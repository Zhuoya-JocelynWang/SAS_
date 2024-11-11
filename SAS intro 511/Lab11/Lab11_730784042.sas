proc printto log='/home/u63982087/BIOS511/Logs/lab11_73XXXXXX.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab11
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.10.02
   
   Purpose : This program is a practice of Proc SGPlots and Proc SGPanel
**************************************************************************************/
%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;

libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab11_73XXXXXX.pdf' startpage = yes;
/* create a pdf file */



/***** Question 1 *****/
title " Boxplots for Tumor Size by Treatment & Stage";
proc sgpanel data = classlib.prostate;/*use the data where tumorsize ≠ -9999*/
  where tumorsize ^= -9999;
  panelby treatment stage/ columns = 4 ;/*panel by thretment and state, set 4 cols*/ 
  hbox tumorsize / outlierattrs=(color=red)
              displaystats = (mean);/*create horizontal box of tumortsize, 
                                     change the outlir to red, display the mean value*/
run;



/***** Question 2 *****/
title "Histogram & Density for BW by Proc Sgpanel";
proc sgpanel data= classlib.preemies noautolegend;/*do not print legend of plots*/
   panelby sex / novarname  ;/*panel by sex without showing the variable name*/
   histogram bw; /*create histogram of bw*/
   density bw/ lineattrs=(color = purple);/*create density line of bw, color it in purple*/
   colaxis label = "Birth Weight";/*apply label to numeric result variable*/
   rowaxis label= "Percent(%)"  values = (0 to 50 by 10);/*label row axis, adjust scale*/
run;


/***** Question 3 *****/ 

proc sort data = classlib.preemies out = my_preemies;
      by sex;/*sort data by sex*/
run;


option nobyline;/*suppress byline*/
title "Histogram & Density for BW by Proc Sgplot ";
title2 '#byvar1 = #byval1 for this graph';/*generate title contain the value of sex*/
proc  sgplot data = my_preemies noautolegend;/*plot without lengend*/
   histogram bw;/*create histogram of bw*/
   density bw/lineattrs=(color = purple) ;/*create density line of bw, color it in purple*/
   by sex; /*show the plot by sex*/
   yaxis label='Percent (%)' values=(0 to 50 by 10);/*label yaxis, ajust the scale*/ 
   xaxis label='Birth Weight';/*label xaxis*/
run;
   


ods pdf close;/*close the pdf file*/

ods _all_ close;
proc printto; run;


