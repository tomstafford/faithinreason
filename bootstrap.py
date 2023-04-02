#standard libraries
import socket #to get host machine identity
import pandas as pd #dataframes
import os #file and folder functions
import numpy as np #number function
import matplotlib.pyplot as plt #plotting function
#matplotlib named colours https://matplotlib.org/stable/gallery/color/named_colors.html
#webscraping
from bs4 import BeautifulSoup
import requests

print("identifying host machine")
#test which machine we are on and set working directory
if 'tom' in socket.gethostname():
    os.chdir('/home/tom/Desktop/faithinreason')
else:
    print("I don't know where I am! ")
    print("Maybe the script will run anyway...")


df = pd.read_csv('data/items.csv')


df.drop('Q19_7',axis=1,inplace=True)

filter_col = [col for col in df if col.startswith('Q19')]

df=df[filter_col]


def cronbach_alpha(df):    # 1. Transform the df into a correlation matrix
    df_corr = df.corr()
    
    # 2.1 Calculate N
    # The number of variables equals the number of columns in the df
    N = df.shape[1]
    
    # 2.2 Calculate R
    # For this, we'll loop through the columns and append every
    # relevant correlation to an array calles "r_s". Then, we'll
    # calculate the mean of "r_s"
    rs = np.array([])
    for i, col in enumerate(df_corr.columns):
        sum_ = df_corr[col][i+1:].values
        rs = np.append(sum_, rs)
    mean_r = np.mean(rs)
    
   # 3. Use the formula to calculate Cronbach's Alpha 
    cronbach_alpha = (N * mean_r) / (1 + (N - 1) * mean_r)
    return cronbach_alpha



cronbach_alpha(df[df.columns[1:4]])


cols=df.columns

import random

bf=pd.DataFrame(columns=['n','c'])

for n in range(1,9):
    for m in range(1,10):
        sample_cols=random.sample(list(cols),n)
        c=cronbach_alpha(df[sample_cols])
        bf.loc[len(bf)] = [n,c]
        
        
bf.groupby('n')['c'].mean()

#cronback for leave one out
for col in cols:
    sample=[c for c in cols if c !=col]
    print(col)
    print(np.round(cronbach_alpha(df[sample]),2))