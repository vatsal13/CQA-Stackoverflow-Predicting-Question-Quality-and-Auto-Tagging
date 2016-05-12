import pandas
import logging
import numpy as np
from optparse import OptionParser
import sys
from time import time
import matplotlib.pyplot as plt
from sklearn.datasets import make_gaussian_quantiles
from sklearn.metrics import accuracy_score
from sklearn.cross_validation import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.linear_model import RidgeClassifier
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import BernoulliNB, MultinomialNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neighbors import NearestCentroid
from sklearn.ensemble import RandomForestClassifier
from sklearn.utils.extmath import density
from sklearn import metrics




def benchmark(clf):
    print('_' * 80)
    print("Training: ")
    print(clf)
    t0 = time()
    clf.fit(X_train, y_train)
    train_time = time() - t0
    print("train time: %0.3fs" % train_time)

    t0 = time()
    pred = clf.predict(X_test)
    test_time = time() - t0
    print("test time:  %0.3fs" % test_time)

    score = metrics.accuracy_score(y_test, pred)
    print("accuracy:   %0.3f" % score)

    clf_descr = str(clf).split('(')[0]
    return clf_descr, score, train_time, test_time

rows = [20000,60000,100000,140000,180000,220000,260000,300000,340000,380000,420000,460000,500000]
for r in rows:
	reader = pandas.read_csv("./MyData1.csv",encoding = "ISO-8859-1",nrows=r)
	train, test = train_test_split(reader, test_size = 0.2)
	train = train.dropna()
	test = test.dropna()
	X_train_In = train[train.columns[1]]
	y_train = train[train.columns[2]]
	X_test_In = test[test.columns[1]]
	y_test = test[test.columns[2]]

	print "-------------running for row number--------------------:",r

	vectorizer = TfidfVectorizer(sublinear_tf=True, max_df=0.5,
                                 stop_words='english')
	X_train = vectorizer.fit_transform(X_train_In)
	X_test = vectorizer.transform(X_test_In	)

   
	results = []
	print('=' * 80)
	print "Ridge Classifier:"
	results.append(benchmark(RidgeClassifier(tol=1e-2, solver="lsqr")))

	print('=' * 80)
	print "LinearSVC l2 penalty:"
	results.append(benchmark(LinearSVC(loss='l2', penalty="l2",
                                            dual=False, tol=1e-3)))
	print('=' * 80)
	print "Naive Bayes:"
	results.append(benchmark(MultinomialNB(alpha=.01)))


