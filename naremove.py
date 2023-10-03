import pandas as pd
def preprocess1():
  
  dataset=pd.read_csv("data/uploaded10.csv",na_values='')                      
  dataset.isnull().sum().sum()
  X=dataset.isnull().sum()
  dataset1=pd.DataFrame(dataset)
  perc = 10.0
  min_count =  int(((100-perc)/100)*dataset1.shape[0] + 1)
  mod_dataset = dataset1.dropna( axis=1,thresh=min_count)
  pd.DataFrame(mod_dataset).to_csv("data/missing_drop_integratednew.csv",index=False)
  return X
