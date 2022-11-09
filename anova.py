import pandas as pd
from pandas import read_csv
import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets

def featurefxnanova():
  
  df=pd.read_csv("data/uploaded3.csv")
  
  n=len(df.axes[1])
  df.head()
  df.groupby(df.columns[-1]).mean()

  y = df.iloc[:,(n-1)]    
  x = df.iloc[:,0:(n-1)]
 
  from sklearn.model_selection import train_test_split
  x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)
  from sklearn.feature_selection import SelectKBest, f_classif
  selector = SelectKBest(f_classif, k=int(n/2))      
  selector.fit(x_train, y_train)
  cols = selector.get_support(indices=True)
  
  df1=df[df.columns[cols]]
  lastcol=df[df.columns[-1]]
  df1=df1.join(lastcol)
  df1.to_csv('data/newdatasetanova.csv',index=False)
  
  return cols
