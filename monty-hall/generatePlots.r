MontyHall2 <- read.table("output_data.txt", header = TRUE, sep = "\t");

png("barplot_output.png", width = 800, height = 600, res = 100);
barplot(table(MontyHall2$prizeDoor),xlab="Door");

dev.off()

t <- table(MontyHall2$outcome, MontyHall2$action)
png("barplot2_output.png", width = 800, height = 600, res = 100);

barplot(t,
        xlab="wins", col=c("grey","black"),legend.text = TRUE, 
        args.legend = list(x = "topright",
                           inset = c(0.8, 0.84)))
dev.off()
