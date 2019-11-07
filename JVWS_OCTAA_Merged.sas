/*Final Data step for merging JVWS and OCTAA*/
DATA PROJECT.JVWS_OCTAA;
	/*Merge Occurs here*/
	MERGE
		PROJECT.JVWS
		PROJECT.OCTAA;
	/*Merge is taken with common variable noc_code*/
	BY noc_code;
RUN;

/*Data is sorted by the sector*/
PROC SORT DATA=PROJECT.JVWS_OCTAA;
	BY appr_sector;
RUN;

/*Average data on the wage and # of job vacancies is outputted by sector in the PROC MEANS step*/
PROC MEANS DATA=PROJECT.JVWS_OCTAA;
	VARIABLE avg_wage avg_vac;
	BY appr_sector;
RUN;

/*Whole table is output, sorted by sector*/
PROC PRINT DATA=PROJECT.JVWS_OCTAA;
	BY appr_sector;
RUN;