/*The JVWS file is imported here*/
DATA JVWS_ROUGH;

	/*Length of some variables is specified*/
	LENGTH 
		name $ 110 
		stat $ 40;
	
	/*Infile statement included*/
	INFILE "/home/aryankukreja0/sasuser.v94/FinalProject/jvws.csv" DELIMITER="," FIRSTOBS=2;
	
	/*The following variables are input from the .csv file*/
	INPUT 
		prov $ 
		name $ 
		noc_code 
		year 
		stat $ 
		val;
RUN;

/*Create the variable for 2015 hourly wage*/
DATA JVWS12015;
	/*Set it to the JVWS.ROUGH*/
	SET WORK.JVWS_ROUGH (WHERE=(stat="Average offered hourly wage (dollars)" AND year= 2015));
	
	/*Set the variable length of relevant variables*/
	LENGTH hour_wage_2015 5;
	
	/*Declare new variable*/
	hour_wage_2015 = val;
RUN;

/*Create the variable for 2016 hourly wage*/
DATA JVWS12016;
	/*Set it to the JVWS.ROUGH*/
	SET WORK.JVWS_ROUGH (WHERE=(stat="Average offered hourly wage (dollars)" AND year= 2016));
	
	/*Set the variable length of relevant variables*/
	LENGTH hour_wage_2016 5;
	
	/*Declare new variable*/
	hour_wage_2016 = val;
RUN;

/*Create the variable for 2015 job vacancies, full pseudocode is same as JVWS2015*/
DATA JVWS22015;
	SET WORK.JVWS_ROUGH (WHERE=(stat="Job vacancies" AND year= 2015));
	LENGTH vac_num_2015 4;
	vac_num_2015 = val;
RUN;

/*Create the variable for 2016 job vacancies, full pseudocode is same as JVWS2015*/
DATA JVWS22016;
	SET WORK.JVWS_ROUGH (WHERE=(stat="Job vacancies" AND year= 2016));
	LENGTH vac_num_2016 4;
	vac_num_2016 = val;
RUN;

/*Output to a csv file*/
ODS CSV FILE = "/home/aryankukreja0/sasuser.v94/FinalProject/JVWS_Datafile_Analysis.csv";

/*Merging all 4 sub-data steps here*/
DATA PROJECT.JVWS;
	MERGE
		JVWS12015
		JVWS12016
		JVWS22015
		JVWS22016;
		
	/*Create new variables accordingly*/
	avg_wage =  (hour_wage_2015 + hour_wage_2016) / 2;
	avg_vac  =  (vac_num_2015 + vac_num_2016) / 2;
RUN;

/*Options go here*/
OPTIONS DATE NODATE NUMBER PAGENO=1 PAGESIZE=30;

/*Output of table in PROC PRINT*/
PROC PRINT DATA=PROJECT.JVWS /*NOOBS*/ SPLIT=";";
	 /*Specify variables*/
	 VAR name noc_code hour_wage_2015 hour_wage_2016 vac_num_2015 vac_num_2016 avg_wage avg_vac;
	 
	 /*Add titles*/
	 TITLE   BOLD UNDERLIN=2  "Job Vacancy and Wage Survey Results - 2015 to 2016";
	 TITLE3  BOLD ITALIC      "Sorted by Year";
	 
	 /*Add footnote*/
	 FOOTNOTE    UNDERLIN=2  "By Aryan Kukreja";
	 FOOTNOTE3   ITALIC      "SAS Summative Project - 2016/2017";
	 
	 /*Add appropriate labels*/
	 LABEL
	 	hour_wage_2015  =  "Average 2015 ;Hourly wage ($)"
	 	vac_num_2015    =  "Job Vacancies ;in 2015"
	 	hour_wage_2016  =  "Average 2016 ;Hourly wage ($)"
	 	vac_num_2016    =  "Job Vacancies ;in 2016"
		noc_code            =  "Apprenticeship ;Trade Code"
	 	name            =  "Name of ;Skilled Trade"
	 	avg_wage		=  "Average Hourly Wage"
	 	avg_vac			=  "Average # of Vacancies";
RUN;

/*Sort Data for other questions*/
PROC SORT DATA=PROJECT.JVWS;
	BY noc_code;
RUN;

ODS CSV CLOSE;