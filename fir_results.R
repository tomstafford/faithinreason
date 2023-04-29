library (qgraph)
library (EGAnet) # requires install.packages('sna')
library(psych) #for scree plot

df <- read.csv(here('data','our_items.csv'))



#full set
Ritems <- dplyr::select(df,c(R1:R8))
#colnames(Ritems) <- gsub("ASRS", "", colnames(asrs_full))

png(here('plots','reason_scree8.png'),height=1500, width=2400,res=360)
scree(Ritems, main='',pc=FALSE)
dev.off()

boot.all <- EGAnet::bootEGA(data = Ritems, model = "glasso", iter = 1000,
                            type = "resampling", typicalStructure = TRUE, 
                            plot.typicalStructure = TRUE, ncores = parallel::detectCores()-1)

png(here('plots','reason_ega.png'),height=1500, width=2400,res=360)
plot(boot.all, 
     layout = 'spring', 
     palette = 'colorblind', 
     height = 5, 
     width = 8,
     plot.args=list(alpha=1,edge.color = c("black","black")))
dev.off()


#reduced set
Ritems <- dplyr::select(df,c(R1:R4,R6:R7))

png(here('plots','reason_scree6.png'),height=1500, width=2400,res=360)
scree(Ritems, main='',pc=FALSE)
dev.off()

boot.six <- EGAnet::bootEGA(data = Ritems, model = "glasso", iter = 1000,
                            type = "resampling", typicalStructure = TRUE, 
                            plot.typicalStructure = TRUE, ncores = parallel::detectCores()-1)

png(here('plots','reason6_ega.png'),height=1500, width=2400,res=360)
plot(boot.six, 
     layout = 'spring', 
     palette = 'colorblind', 
     height = 5, 
     width = 8,
     plot.args=list(alpha=1,edge.color = c("black","black")))
dev.off()
