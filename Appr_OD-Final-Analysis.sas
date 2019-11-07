LIBNAME PROJECT "/home/aryankukreja0/sasuser.v94/FinalProject/Final_Dataset_Library";
/* Creates a custom libname for analzing Appr file*/

ODS CSV FILE="/home/aryankukreja0/sasuser.v94/FinalProject/Appr_OD_Datafile_Analysis.csv";
/* Creates the custom csv file back into the original directory */

DATA PROJECT.APPR_OD;
	INFILE "/home/aryankukreja0/sasuser.v94/FinalProject/Appr_OD.csv" DELIMITER="," FIRSTOBS=2;
	INPUT
	/* all of the variables being created for the data set (All numeric)*/
		repyr $
		appr_trade_code $
		appr_sponsors 
		appr_pub_tdas 
		appr_priv_tdas;
	
	total = appr_pub_tdas + appr_priv_tdas;
RUN;

/*asisgned options for report*/
OPTION DATE NODATE NUMBER PAGENO=1 PAGESIZE=30;

PROC PRINT DATA=PROJECT.APPR_OD NOOBS SPLIT=";";
	/*Add appropriate Labels for Variables so they can be understood in output*/
	LABEL
		repyr            =  "Reporting ;Year"
		appr_trade_code  =  "Apprenticeship ;Trade Code"
		appr_sponsors    =  "Number of ;Sponsors"
		appr_pub_tdas    =  "Number of ;Apprenticeship ;Public TDAs"
		appr_priv_tdas   =  "Number of ;Apprenticeship ;Private TDAs"
		total            =  "Total Number ;of Apprenticeship ;TDAs";
	/* Shows all data in each year*/
	BY repyr;
RUN;

ODS CSV CLOSE;