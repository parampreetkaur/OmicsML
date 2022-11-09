from numpy import isnan
import numpy as np
from pandas import read_csv
import pandas as pd
from sklearn.impute import KNNImputer

def preprocess():
  dataframe = pd.read_csv("data/uploaded8.csv",na_values='?')
 
  data = dataframe.values
  ix = [i for i in range(data.shape[1]) if i != 23]
  X, y = data[:, ix], data[:, 23]
  
  print('Missing: %d' % sum(pd.isnull(X).flatten()))
 
  imputer = KNNImputer()
  
  imputer.fit(X)
  
  Xtrans = imputer.transform(X)
  
  print('Missing: %d' % sum(pd.isnull(Xtrans).flatten()))
  
  pd.DataFrame(Xtrans).to_csv("data/missing_new.csv",index=False)
  return Xtrans
