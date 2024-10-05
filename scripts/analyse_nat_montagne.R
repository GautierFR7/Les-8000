library(rAmCharts)
library(vcd)

contingency_table <- table(data_total$region, data_total$Mountain)
chi_square_test <- chisq.test(contingency_table)
summary(chi_square_test)

association_measure <- assocstats(contingency_table)
association_measure

contingency_table <- as.matrix(contingency_table)
heatmap(contingency_table)
