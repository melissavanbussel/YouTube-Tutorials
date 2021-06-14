proc options option=RLANG;
run;

/* Export SAS dataset to R, manipulate it (first arg = SAS data, second arg = R dataframe name) */ 
proc iml; 
	call ExportDataSetToR("sashelp.Class", "classdf");
	submit / R; 
		names(dframe)
		lmod <- lm(Weight ~ Height + Age + Sex, data = classdf)	
		lmod_sum <- summary(lmod)
		mytest <- lmod_sum$coefficients
		mytest
	endsubmit;
run; 

/* Can you reuse data from R you've previously defined? NO. */ 
proc iml; 
	submit / R;
		x <- 3 
		x
		mytest 
	endsubmit; 
run; 

/* Loading packages (exactly as you expect) */ 
proc iml;
	submit / R;
		library(MASS)
		lm(VitC ~ Cult + Date + HeadWt, data = cabbages)
	endsubmit;
run;

/* Exporting data back to SAS (first arg = SAS, second arg = R); goes to work library */ 
proc iml;
	submit / R;
		library(MASS)  
	endsubmit; 
	call ImportDataSetFromR("sascabbages", "cabbages");
run;

/* Create ggalluvial / Sankey diagram plot */
proc iml;
	submit / R;
		# install.packages("ggalluvial", repos = "http://cran.us.r-project.org")
		library(tidyverse)
		library(ggalluvial)
		ggplot(as.data.frame(UCBAdmissions), aes(y = Freq, axis1 = Gender, axis2 = Dept)) +
  			geom_alluvium(aes(fill = Admit), width = 1/12) +
  			geom_stratum(width = 1/12, fill = "black", color = "grey") +
  			geom_label(stat = "stratum", aes(label = after_stat(stratum))) +
  			scale_x_discrete(limits = c("Gender", "Dept"), expand = c(.05, .05)) +
  			scale_fill_brewer(type = "qual", palette = "Set1") +
  			ggtitle("UC Berkeley admissions and rejections, by sex and department")
		ggsave("C:/Users/16138/Desktop/ggalluvialtest.png")
	endsubmit; 
run;
