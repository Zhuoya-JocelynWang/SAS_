proc printto log='/home/u63982087/BIOS511/Logs/lab7_73XXXXXX.log' new;run;

/************************************************************************************
   Project: BIOS 511

   Program Name: Lab7
   
   Author : Jocelyn(Zhuoya) Wang
   
   Date Created: 2024.09.11
   
   Purpose : This program is designed to practice generating reports with proc report
**************************************************************************************/
 
%put %upcase(no)TE: Program being run by 73XXXXXX;
options nofullstimer; 

 
 
libname classlib '~/my_shared_file_links/u49231441/Data' access = readonly; 
run; /*access a libref in class folder*/


/* Question 1*/

proc report data = classlib.learn_modalities(obs = 50); /* report LM dataset&display the first 50 obs*/

    where state = "AZ"; /* use the data where state is Arizona*/
   
    column district_name ("Analysis Variable" learning_modality student_count);
    /* use the three variables, 
    and provide spanning header above both LM & Student Counts*/   
   
    title "Table of Learning Modality & Student Count for Districts in Arizona";
run;
  

/* Question 2*/

proc report data = classlib.diabetes; /* Make report for diabetes dataset*/
  column location frame waist hip;  /*use the four columns for further analysis*/
 
  define location /group; /*group the data by location*/
  define frame / group;/*group the data by frame*/
 
  define waist / "Max Waist" max; /* request maximum value for waist & label it*/
  define hip/ "Max Hip" max;/* request maximum value for Hip & label it*/
 
  title "Max Waist and Hip for Each Body Frame in Different Location"; 
run;


/* Question 3*/

proc report data = classlib.budget;/* Make report for budget dataset*/
    column department, (yr2018 yr2019 yr2020); /*use the department, year2018 to year 2020 
                                                columns for further analysis*/
   
    define department / across " " ;/* make department as spanning header abover others*/ 
    title "Budget for Each Apartment from 2018 to 2020";
run; 
    
/* Question 4*/

proc report data = classlib.employee_donations; /* Make report for ED dataset*/

     column paid_by qtr:;/*use the variables called paid_by and quarter 1-4*/
     define paid_by/ group ; /* group the data by paid_by*/
    
     format qtr: dollar8.; /*change the formate of obs in quarter 1-4*/
     define qtr4/ style(column)=[background = lightyellow]; /*apply lightyellow bg to qtr4 col*/
    
     title "Summary of Employee Donations by Payment Type From Qtr1 to Qtr4";
run;

/* Question 5*/

proc report data = sashelp.cars;/* Make report for cars dataset*/

   column origin type, n; /* use column origin and type, and we also want the counts (n)for type*/
  
   define origin/ group " "; /*group the data by origin without labels*/
   define type / across "  ";/*Use type as spanning headers without new labels*/
   define n / " "; /* counts of types without labels*/
  
   options missing = 0; /* replace missing value dot with 0*/
  
   title "Counts for Different Type of Car in Each Location";
run;
   
proc printto; run;
   
  
