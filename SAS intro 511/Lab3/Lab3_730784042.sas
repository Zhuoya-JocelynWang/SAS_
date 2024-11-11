proc printto log='/home/u63982087/BIOS511/Logs/lab3_73XXXXXX.log' new;run;
/* Project: BIOS 511

   Program Name: Lab3
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.08.26
   
   Purpose : This program is designed to practice Library and GlobalStatements */

%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer;

/*4*/
libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
/*accesse a libref that points to the Data foler under u49231441 folder under the  my_shared_file_links folder*/
run;

/*5*/
libname mylib '/home/u63982087/BIOS511/Data';
/*accesse a libref that points to the Data foler under my own BIOS511 folder*/
run;  

/*6*/
data work.temp_dmvs ; /*create a dataset called temp_dmvs in the temporary library called work*/ 
set classlib.dmvs; /*pulling in data from the dmvs dataset located in a permanenet library called classlib*/
run; 

/*7*/
data mylib.perm_dmvs;/* a dataset perm_dmvs was created in a pernmant library called mylib*/
set classlib.dmvs; /*pulling in data from the dmvs dataset located in a permanenet library called classlib*/
run;

/*8*/
options obs = 5; /* read&present the first 5 rows or observations in the dataset */
title "Preview of Temp_dmvs Dataset from Class Library"; /*provide title for the output*/
footnote "Data in temporary'work' library was extracted 
from 'classlib.dmvs' and the first 5 observations were presented."; /*provide footnote for the output*/
proc print data = temp_dmvs;/*print result*/
run;

/*9*/
options VALIDVARNAME = V7; /*change the rules for valid SAS names to V7 standard*/
options YEARCUTOFF = 1920; /*specifies the first year of a hundred-year span, interpret two-digit dates between 1920 to 2019*/

/*10*/ 
/*verify the changes in #9 */
proc options option=validvarname; 
run;
proc options option=yearcutoff;
run;

proc printto; run;
