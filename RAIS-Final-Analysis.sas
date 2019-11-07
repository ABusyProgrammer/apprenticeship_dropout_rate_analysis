ODS CSV FILE="/home/aryankukreja0/sasuser.v94/FinalProject/RAIS_Datafile_Analysis.csv";
/* Creates the custom csv file back into the original directory */

DATA RAIS_Fixed;
	INFILE "/home/aryankukreja0/sasuser.v94/FinalProject/RAIS.csv" DELIMITER="," FIRSTOBS=2;
	LENGTH 
/* Set the length for character varibles */
		repyr $ 4 
		reg_status $ 50 
		appr_trade_name $ 65 
		comp_vol $ 10;
/* all of the variables being created for the data set (Some numeric)*/
	INPUT
		repyr $
		reg_status $
		appr_trade_code $
		appr_trade_name $
		comp_vol $
		gender $
		total_reg 
		mean_age 
		sd_age 
		total_NA
		total_cont 
		total_comp 
		total_disc 
		mean_reg_dur $
		mean_date_reg;
RUN;

/*  RAIS data set that removes data under total disconnected that is less than 0*/
DATA RAIS_MOD;
	SET WORK.RAIS_Fixed (WHERE=(total_disc > 0));
	total = total_NA + total_disc + total_comp + total_cont;
	perc_disc = (total_disc / total) * 100;
RUN;

/* RAIS data set that creates Percent Completion of Apprenticeship Training from variables total_comp and total_reg (perc_comp)*/
DATA RAIS_NEW;
	SET WORK.RAIS_Fixed;
	total = total_comp + total_cont;
	perc_comp = (total_comp / total_reg) * 100;
RUN;
/* RAIS data set that use where to filter perc_disc greater than 30*/
DATA PROJECT.RAIS;
	SET WORK.RAIS_MOD(WHERE=(perc_disc > 30));
RUN;
/* RAIS data set that use where to filter perc_disc greater than 30*/
DATA PROJECT.RAIS2;
	SET WORK.RAIS_MOD(WHERE=(perc_disc < 3));
RUN;

OPTIONS DATE NODATE NUMBER PAGENO=1 PAGESIZE=30;
/* sorts the data by year so PROC PRINT can show the data in each year*/
PROC SORT DATA=PROJECT.RAIS;
	by repyr;
RUN;
/* Means info for the RAIS_New data set*/
PROC MEANS DATA=RAIS_New;
	VARIABLE total total_cont total_comp perc_comp;
	BY repyr;
RUN;
/* Means info for the RAIS_Fixed data set*/
PROC MEANS DATA=RAIS_Fixed;
	VARIABLE mean_age total_reg total_cont total_comp;
	BY repyr;
RUN;

/* Prints the filter and fixed data sets from the orignal data set(RAIS_supressed)*/
PROC PRINT DATA=RAIS_New;
	/* Label/Dictionary of every varible*/
	LABEL
		repyr            =  "Calendar Year ;for a Record"
		reg_status       =  "Registration ;Status"
		appr_trade_code  =  "Apprenticeship ;Trade Code"
		appr_trade_name  =  "Apprenticeship Trade Name"
		comp_vol         =  "Compulsory ;or Voluntary?"
		gender           =  "Gender of ;Individual"
		total_reg        =  "Total Individuals ;Registered in the ;Program"
		mean_age         =  "Mean Age of ;Individuals in ;Record"
		sd_age           =  "Standard ;Deviation of ;Age in Record"
		total_NA         =  "Not Applicable ;for Direct ;Qualification ;in Record"
		total_cont	     =  "Number of ;Individuals ;Continuing Program"
		total_comp       =  "Number of ;Individuals ;Who Completed ;Program"
		total_disc       =  "Number of ;Individuals ;Who Dsicontinued ;Program"
		mean_reg_dur     =  "Average Time ;Students are ;Registered in ;this Program"
		mean_date_reg    =  "Average ;Registration ;Date for Students"
		perc_comp		 =  "Percent Completion of Apprenticeship Training"
		total			 =  "Total # of students that didn't discontinue program";
	BY repyr;
	/* Goes by year, this way we can see the info for trades in each year*/
	SUM total_reg total_NA total_cont total_comp total_disc;
	/* The totals for most of the numeric variables.*/
RUN;


PROC PRINT DATA=PROJECT.RAIS2 SPLIT=";";
	LABEL
		repyr            =  "Calendar Year ;for a Record"
		reg_status       =  "Registration ;Status"
		appr_trade_code  =  "Apprenticeship ;Trade Code"
		appr_trade_name  =  "Apprenticeship Trade Name"
		comp_vol         =  "Compulsory ;or Voluntary?"
		gender           =  "Gender of ;Individual"
		total_reg        =  "Total Individuals ;Registered in the ;Program"
		mean_age         =  "Mean Age of ;Individuals in ;Record"
		sd_age           =  "Standard ;Deviation of ;Age in Record"
		total_NA         =  "Not Applicable ;for Direct ;Qualification ;in Record"
		total_cont	     =  "Number of ;Individuals ;Continuing Program"
		total_comp       =  "Number of ;Individuals ;Who Completed ;Program"
		total_disc       =  "Number of ;Individuals ;Who Dsicontinued ;Program"
		mean_reg_dur     =  "Average Time ;Students are ;Registered in ;this Program"
		mean_date_reg    =  "Average ;Registration ;Date for Students";
RUN;

PROC SORT DATA=PROJECT.RAIS;
	BY appr_trade_code;
RUN;

ODS CSV CLOSE;