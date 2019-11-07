/*Data step for merging JVWS.csv and RAIS.csv*/
DATA PROJECT.JVWS_RAIS_MERGED;
	/*Merge step occurs here*/
	MERGE 
		PROJECT.OCTAA
		PROJECT.RAIS;
RUN;

/*Print out table of merged JVWS and RAIS*/
PROC PRINT DATA=PROJECT.JVWS_RAIS_MERGED;
RUN;