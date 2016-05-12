#!/usr/bin/python

__author__ = 'Vatsal'

import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.cross_validation import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.pipeline import Pipeline
from sklearn.cross_validation import StratifiedKFold

def main():
	print 'Starting Training'
	print 'Starting load of the X Train data'

	f = open("qwer.csv")
	x_train_data = np.loadtxt(f, delimiter=",")
	print len(x_train_data[1])
	print 'asdsa'
	y_train_data = x_train_data[:,[18]].T[0]
	print y_train_data
	x_train_data = x_train_data[:,[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]]
	print x_train_data
	# print 'Finished load of the X Train data'
	# print 'Starting load of the Y Train data'
	# f = open("train_label.txt")
	# y_train_data = np.loadtxt(f, delimiter=",")
	# print 'Finished load of the Y Train data'

	from sklearn.linear_model import LogisticRegression
	from sklearn.decomposition import PCA
	from sklearn.linear_model import LogisticRegression
	# pca = PCA(n_components=15)
	# lr = LogisticRegression()
	# X_train_pca = pca.fit_transform(x_train_data)
	
	# X_test_pca = pca.transform(X_test_std)

	pipe_lr = Pipeline([('svc', LogisticRegression(random_state=0,penalty='l2',C=1.0 ))])

	kfold = StratifiedKFold(y=y_train_data,n_folds=10,random_state=1)
	scores = []
	
	for k, (train, test) in enumerate(kfold):
		pipe_lr.fit(x_train_data[train], y_train_data[train])
		score = pipe_lr.score(x_train_data[test], y_train_data[test])
		scores.append(score)
		# print('Fold: %s, Class dist.: %s, Acc: %.3f' % (k+1,np.bincount(y_train_data[train]), score))

	# x_train_data, x_test_data, y_train_data, y_test_data = train_test_split(x_train_data, y_train_data, test_size=0.3)
	
	print('CV accuracy: %.3f +/- %.3f' % (np.mean(scores), np.std(scores)))

	# pipe_lr.fit(x_train_data, y_train_data)
	# print('Test Accuracy: %.3f' % pipe_lr.score(x_test_data, y_test_data))

	
	#x_train_std = standardize(x_train_data)
	
	# print 'Started training of training data'
	# svm = SVC(kernel='linear', C=2.0, random_state=0)
	# svm.fit(x_train_data, y_train_data)
	
	# print 'Finished load of the Y Train data'
	# print 'Starting load of the X Test data'
	# # f = open("test_data.txt")
	# # x_test_data = np.loadtxt(f, delimiter=",")
	# print 'Finished load of the X Test data'
	# #x_test_std = standardize(x_test_data)
	# y_pred = svm.predict(x_test_data)
	# print('Accuracy: %.2f' % accuracy_score(y_test_data, y_pred))	
	# # for i in y_pred:
	# # 	print int(i)

# standardizes the data
def standardize(x_data):        
	print 'Started standardizing of the data'
	sc = StandardScaler()
	sc.fit(x_data)	
	x_std = sc.transform(x_data)        
	print 'Finished standardizing of the data'
	return x_std

if __name__ == "__main__": main()
