library (qgraph)
library (EGAnet) # requires install.packages('sna')


df <- read.csv(here('data','items.csv'))
Ritems <- dplyr::select(df,c(Q19_1:Q19_6,Q19_8:Q19_9))

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



Ritems <- dplyr::select(df,c(Q19_1:Q19_4,Q19_6,Q19_8))


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
