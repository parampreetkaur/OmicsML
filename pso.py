import numpy as np
import pandas as pd
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from FS.pso import jfs   
import matplotlib.pyplot as plt

def featurefxn3():

  datao  = pd.read_csv('data/uploaded5.csv')
  data  = datao.values
  feat  = np.asarray(data[:, 0:-1])
  label = np.asarray(data[:, -1])


  xtrain, xtest, ytrain, ytest = train_test_split(feat, label, test_size=0.3, stratify=label)       
  fold = {'xt':xtrain, 'yt':ytrain, 'xv':xtest, 'yv':ytest}


  k    = 5     
  N    = 10    
  T    = 100   
  opts = {'k':k, 'fold':fold, 'N':N, 'T':T}


  fmdl = jfs(feat, label, opts)
  sf   = fmdl['sf']
  data1=datao[datao.columns[sf]]
  lastcol=datao[datao.columns[-1]]
  data1=data1.join(lastcol)
  data1.to_csv('data/newdatasetpso.csv',index=False)
  return sf
  


  num_train = np.size(xtrain, 0)
  num_valid = np.size(xtest, 0)
  x_train   = xtrain[:, sf]
  y_train   = ytrain.reshape(num_train)  
  x_valid   = xtest[:, sf]
  y_valid   = ytest.reshape(num_valid)  

  mdl       = KNeighborsClassifier(n_neighbors = k) 
  mdl.fit(x_train, y_train)


  y_pred    = mdl.predict(x_valid)
  Acc       = np.sum(y_valid == y_pred)  / num_valid
  print("Accuracy:", 100 * Acc)


  num_feat = fmdl['nf']
  print("Feature Size:", num_feat)
 


  curve   = fmdl['c']
  curve   = curve.reshape(np.size(curve,1))
  x       = np.arange(0, opts['T'], 1.0) + 1.0

  fig, ax = plt.subplots()
  ax.plot(x, curve, 'o-')
  ax.set_xlabel('Number of Iterations')
  ax.set_ylabel('Fitness')
  ax.set_title('PSO')
  ax.grid()
  plt.show()


