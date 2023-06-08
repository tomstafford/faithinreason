library(here)
library(tidyverse)

# parameters for figures etc
figsize<-'68%'
figdpi <- 320 #when saving
makeegafigs <- FALSE #a toggle, whether to run fir_results.R or not
alphaval=0.3

file='final_responses2023-06-02.csv' #data file, numerical answers, downloaded from Qualtrics
df <- read.csv(here('data',file))[-1:-2,]

#remove people who don't finish [these have been removed already]
df <- df %>% dplyr::filter(Progress == 100)

#just the columns we're interested in
df <- df[grepl("FIR|ELECT_PAR",colnames(df))]

#check types -> all are character, not numeric
sapply(df, class)

#convert to numeric

# Create a recode function
recode_response <- function(x) {
  recode(x, 
         "Strongly disagree" = 1, 
         "Disagree" = 2, 
         "Somewhat disagree" = 3, 
         "Neither agree nor disagree" = 4, 
         "Somewhat agree" = 5, 
         "Agree" = 6, 
         "Strongly agree" = 7)
}

# Use mutate_at to apply the recode function to multiple columns
df <- df %>% 
  mutate_at(vars(starts_with("FIR")), recode_response)

# Create a recode function
recode_response <- function(x) {
  recode(x, 
         "No, I have not" = 0, 
         "Yes, I have" = 1)
}

df <- df %>% 
  mutate_at(vars(starts_with("ELECT_PAR")), recode_response)


#Some items are reverse coded. Let's code all so higher scores = high faith in rationality
#FIR_1 to FIR_4
df <- df %>% dplyr::mutate(across(FIR_1:FIR_4, ~ 8 - .))

write_csv(df,here('data','fir_Ritems.csv')) #export the items which are the focus of this paper

'''

FIR

The typical person is often irrational.	
People are often misinformed on important issues.	
People are too easily manipulated.	
People often act for reasons they don’t understand or endorse.	
The average person can be persuaded to change their mind if given good reasons.	
Most people hold accurate views about the world.	
An individuals beliefs about the world are generally coherent.	
Peoples behaviour is generally consistent with their beliefs.


ELECT_PAR

During the last 12 months, have you done any of the following? -

Done any work on behalf of a political party or political action group.
Given any money to a political party, organisation or cause.
Displayed an election poster.
Listened to or watched a party election broadcast.
Read a campaign leaflet/letter, text message or email from a political party.
Tried to persuade somebody which party they should vote for.
'''

# Calculate the mean of the columns starting with "FIR"
df <- df %>% 
  rowwise() %>% 
  mutate(mean_fir = mean(c_across(starts_with("FIR")), na.rm = TRUE))

df <- df %>% 
  rowwise() %>% 
  mutate(sum_electpar = sum(c_across(starts_with("ELECT_PAR")), na.rm = TRUE))


# plots

p <- ggplot(data = df,mapping= aes(mean_fir))
p + geom_histogram(fill="darkorchid2",color="black",binwidth=0.5) +
  scale_x_continuous(breaks = 1:7, 
                     labels = c("1\nStrongly\ndisagree","2","3","4\nneutral","5","6","7\nStrongly\nagree")) +
  labs(x = "Faith in reason") +
  xlim(1,7)


p <- ggplot(data = df,mapping= aes(sum_electpar))
p + geom_histogram(fill="royalblue",color="black",binwidth=1) +
  labs(x = "Election participation")


p <- ggplot(data = df,mapping= aes(x=mean_fir,y=sum_electpar))
p + 
  geom_point(position = position_jitter(height= 0.05,width = 0.0),alpha=alphaval)+
  geom_smooth(method=lm) +
  labs(x = "Faith in reason",
       y = "Election participation")


p <- ggplot(data =df, mapping = aes(x=sum_electpar,y=mean_fir))
p+ geom_boxplot()


ff_summarised <- df %>%
  group_by(sum_electpar) %>%
  summarise(mean_value = mean(mean_fir, na.rm = TRUE),
            count = n(),
            .groups = "drop")


#use 6item scale
ggsave(here('plots','fir2_fir-electpar.png'),dpi=figdpi)  



#calculate mean from six items
df <- df %>% rowwise() %>% mutate(fir = mean(c_across(c(FIR_1:FIR_4,FIR_6,FIR_7))))

# calculate mean of y for each value of x
mean_df <- df %>% group_by(sum_electpar) %>% summarize(mean_fir = mean(fir),
                                               se_fir=sd(fir)/sqrt(n())
)

# create bar chart
ggplot(mean_df, aes(sum_electpar, mean_fir)) + 
  geom_bar(stat = "identity", fill = "blue") + 
  geom_errorbar(aes(ymin=mean_fir-se_fir, ymax=mean_fir+se_fir),
                width=.2,
                position=position_dodge(.9)) +
  coord_cartesian(ylim=c(1,7)) +
  scale_x_continuous(breaks=0:6,) +
  labs(x = "Election participation", y = "Faith in Reason (+/- standard error")


ggsave(here('plots','fir2_electionpar-fir.png'),dpi=figdpi)  


