ODS CSV FILE = "/home/aryankukreja0/sasuser.v94/FinalProject/OCTAA_Dataset_Analysis.csv";
/* Creates the custom csv file back into the original directory */

DATA PROJECT.OCTAA;
	INFILE "/home/aryankukreja0/sasuser.v94/FinalProject/octaa.csv" DELIMITER="," FIRSTOBS=2;
	/* Creates the custom csv file back into the original directory */
	LENGTH 
	/* Set the length for character varibles */
		appr_trade_name $ 100
		appr_trade_code $ 30
		acad_entry_req  $ 100;
	INPUT
/* all of the variables being created for the data set (Some numeric)*/
		appr_trade_name $ 
		appr_trade_code $
		noc_code 
		appr_sector $
		appr_ratio $ /* Interesting; look into more*/
		tax_train_cred $ 
		fact_sheets $ 
		red_seal $ 
		cofq $ 
		otj_hours 
		in_class_hours 
		train_std_year 
		curr_std_year 
		trade_board $
		acad_entry_req $;
RUN;

OPTIONS DATE NODATE NUMBER PAGENO=1 PAGESIZE=30;

PROC SORT DATA=PROJECT.OCTAA;
	BY noc_code;
RUN;
/* Sorts the data by noc_code so PROC PRINT can show the data in each Trade Code*/

PROC PRINT DATA=PROJECT.OCTAA NOOBS SPLIT=";";
	/* Creates a custom  title and footnote for the report*/
	TITLE   BOLD UNDERLIN=2  "The Ontario College of Trades (OCoT) Trade Description";
	TITLE3  BOLD ITALIC      "Descriptive Statistics for 156 Different Trades";

	FOOTNOTE  UNDERLIN=2  "By Aryan Kukreja";
	FOOTNOTE  ITALIC      "SAS Summative Project 2016/2017";
	/* Label/Dictionary of every varible*/
	LABEL
		appr_trade_name  =  "Name of ;Trade"
		noc_code         =  "NOC Code ;for Trade"
		appr_sector      =  "Apprenticeship ;Sector"
		appr_ratio       =  "Ratio of Students ;to Journeymen ;Available?"
		tax_train_cred   =  "Tax Training ;Credit?"
		fact_sheets      =  "Fact Sheets ;Available?"
		red_seal         =  "Red Seal ;Trade Status?"
		cofq             =  "Qualification ;Exam for this Trade?"
		otj_hours        =  "Training Hours ;Required"
		in_class_hours   =  "In-Class Hours ;Required"
		train_std_year   =  "Establishment of Year of Workplace ;Apprenticeship ;Training Standard"
		curr_std_year    =  "Establishment of Year ;of Curriculum Training ;Standard"
		trade_board      =  "Trade Board ;Exists?"
		acad_entry_req   =  "Academic Entry ;Requirements";
	/*Order in which the varibles are going to be shown*/
	VAR 
		appr_trade_name noc_code appr_sector appr_ratio tax_train_cred red_seal cofq otj_hours 
		in_class_hours train_std_year curr_std_year trade_board acad_entry_req;
RUN;

ODS CSV CLOSE;