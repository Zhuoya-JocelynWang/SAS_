proc printto log='/home/u63982087/BIOS511/Logs/lab19_730784042.log' new;run;


/************************************************************************************
   Project: BIOS 511

   Program Name: Lab19
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.11.04
   
   Purpose : This program is a practice of FIRST. LAST. and RETAIN Statement
**************************************************************************************/

%put %upcase(no)TE: Program being run by 730784042;
options nofullstimer;


libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/

ods pdf file = '/home/u63982087/BIOS511/Output/lab19_730784042.pdf' startpage = yes;
/* create a pdf file */



/***** Question 1 *****/
proc sort data = classlib.depression out = dp ;
by AcuteIllness TreatmentRecommended;
run; /*sort data by the two variable and output dataset named dp*/


data q1_data; 
  set dp; /* create new dataset from dp and sort by the two variabes*/
  by AcuteIllness TreatmentRecommended;
  
  retain total_bother total_sleep;/*retain the two variables from iteration steps*/
  
  if first.TreatmentRecommended then do;/* Keep only the first adverse event for each treatment*/
    total_bother = 0;
    total_sleep = 0;
  end;/*reset total variables to 9 at the start of treatment*/
  
  if  statement12 > 0 then total_bother +1; /*calculate the number of subjects whose answer >0*/
  if  statement15 > 0 then total_sleep +1;/*calculate the number of subjects whose answer >0*/
  
  if last.TreatmentRecommended then output; /*mark last obs for the two variables*/
  
  keep AcuteIllness TreatmentRecommended total_bother total_sleep; /*keep 4 vars*/
  
  label total_bother = "Totoal Number of Participants Bothered by Things"
        total_sleep = "Total Number of Participants with Restless Sleep";
run;        
  
 
/***** Question 2 *****/
proc print data = q1_data label;
    title "Q2: Output Table2.1 by Proc Print"; 
run;/*print the result by proc print from 
    last question for both vars*/


proc freq data = classlib.depression;

    tables AcuteIllness*TreatmentRecommended*statement12/list nocum; /*print the total result of
                                                  bothered things directly from depression dataset*/
                                                        
    tables AcuteIllness*TreatmentRecommended*statement15/list nocum; /*print the total result of restless sleep
                                                  directly from depression dataset*/
     title "Q2: Output Table2.2(Bothered Things) & Table2.3(Restless Sleep)  by Proc Freq ";                                            
run;




/***** Question 3 *****/
data q3_tempae; /*create new dataset*/
 set classlib.ae;
 
 if length(aestdtc) = 7 then aestdtc = catx('-',aestdtc,'01');/*standardize the value of start date*/
 if length(aeendtc) = 7 then aeendtc = catx('-',aeendtc,'01');/*standardize the value of end date*/
 
 num_aestdt = input(aestdtc, yymmdd10.);/*create numeric version of AE start date*/
 num_aeenddt = input(aeendtc, yymmdd10.);/*create numeric version of AE end date*/
 
 format num_aestdt num_aeenddt date9.;/*change format*/
run;


/***** Question 4 *****/ 
proc sort data = q3_tempae out = q4_ae;
 by usubjid num_aestdt;/*sort dataset by subject and numeric startdate*/
run;


/***** Question 5 *****/ 
proc sort data = classlib.dm out = dm; by usubjid;/*sort dm by subject*/

data q5_merged; /*merged dataset*/
  merge q4_ae(in = inae) dm; /*merge the two sets and add index of ae*/
  by usubjid;/*by subject*/
  if inae =1; /*only keep subjects that have adverse event*/
  
  if first.usubjid; /*Keep only the first adverse event for each subject*/
 
  num_first_st = input(rfxstdtc, yymmdd10.); /*make the data numeric*/
  total_days = num_aestdt - num_first_st;/*calculate the number of days*/
 
  drop num_first_st;/*drop it*/
  
  label total_days = "Total Days to the first adverse event";
run;


/***** Question 6 *****/ 
proc sort data = q5_merged;
by arm; /*sort data by arm*/
run;


proc sgplot data = q5_merged;/*apply sgplot to the data*/
  by arm;
  histogram total_days;/*create histogram for each arm*/
  density total_days/ type = normal lineattrs=(color= red);/*density plot with normal*/
  density total_days/ type = kernel lineattrs=(color= black); /*density plot with kernel*/
  
  label arm = "Described Arm";/*label the arm variable*/
  keylegend/ location = inside position = topright across =1;/*adjust the legen position*/
  title "Q6: Plot of the Number of Days to The First Adverse Event";
run;



ods pdf close;/*close the pdf file*/
ods _all_ close;

proc printto; run;



