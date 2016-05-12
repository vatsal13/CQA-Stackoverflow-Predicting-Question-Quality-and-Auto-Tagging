__author__ = 'Tejal'

from sklearn import cross_validation
from sklearn import metrics
from sklearn.naive_bayes import GaussianNB
from sklearn.ensemble import ExtraTreesClassifier
from sklearn import preprocessing
from sklearn import linear_model
from sklearn import svm
from sklearn import neighbors
from sklearn import tree
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import GradientBoostingClassifier

def fun():
    print "hello tejal"

if __name__ == '__main__':

    data = []
    target = []

    f = open("Train1.txt",'r')
    for line in f:
        linestrlist = line.strip().split(',')
        linenumlist = []
        for str in linestrlist:
            if '.' in str:
                linenumlist.append(float(str))
            else:
                linenumlist.append(int(str))
        data.append(linenumlist)
    f.close()

    f = open("TrainLabel1.txt",'r')
    for line in f:
        target.append(int(line.strip()))
    f.close()

    # print data
    # print target

    # Standardizing the data
    max_abs_scaler = preprocessing.MaxAbsScaler()
    data_maxabs = max_abs_scaler.fit_transform(data)

    # print data_maxabs

    n_samples = 1000

    model = GaussianNB()
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "GaussianNB "
    print scores.mean()

    model = linear_model.Ridge(alpha = .5)
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "Ridge "
    print scores.mean()

    model = linear_model.Lasso(alpha=.1)
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "Lasso "
    print scores.mean()

    model = linear_model.LassoLars(alpha=.1)
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "LassoLars "
    print scores.mean()

    model = linear_model.BayesianRidge()
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "BayesianRidge "
    print scores.mean()

    model = svm.SVC()
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "SVC "
    print scores.mean()

    model = neighbors.KNeighborsClassifier(n_neighbors=15, weights='uniform')
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "KNeighborsClassifier uniform "
    print scores.mean()

    model = neighbors.KNeighborsClassifier(n_neighbors=15, weights='distance')
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "KNeighborsClassifier distance "
    print scores.mean()

    model = tree.DecisionTreeClassifier()
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "DecisionTreeClassifier "
    print scores.mean()

    model = RandomForestClassifier()
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "RandomForestClassifier "
    print scores.mean()

    model = ExtraTreesClassifier()
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "ExtraTreesClassifier "
    print scores.mean()

    model = SGDClassifier(loss="hinge", penalty="l2")
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "SGDClassifier "
    print scores.mean()

    model = AdaBoostClassifier(n_estimators=100)
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "AdaBoostClassifier "
    print scores.mean()

    model = GradientBoostingClassifier(n_estimators=100, learning_rate=1.0, max_depth=1, random_state=0)
    model.fit(data_maxabs, target)
    cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    print "GradientBoostingClassifier "
    print scores.mean()

    # model = ExtraTreesClassifier()
    # model.fit(data_maxabs, target)
    # cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    # scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    # print "ExtraTreesClassifier "
    # print scores.mean()
    #
    # model = ExtraTreesClassifier()
    # model.fit(data_maxabs, target)
    # cv = cross_validation.ShuffleSplit(n_samples, n_iter=10, test_size=0.1, random_state=0)
    # scores = cross_validation.cross_val_score(model, data_maxabs, target, cv=cv)
    # print "ExtraTreesClassifier "
    # print scores.mean()



    # feature selection
    # model = ExtraTreesClassifier()
    # model.fit(data, target)
    # print(model.feature_importances_)

    # X_train, X_test, y_train, y_test = cross_validation.train_test_split(data_maxabs, target, test_size=0.1, random_state=0)
    # clf = model.fit(X_train, y_train)
    # print clf.score(X_test, y_test)



    # expected = target
    # predicted = model.predict(data)
    # print(metrics.classification_report(expected, predicted))
    # print(metrics.confusion_matrix(expected, predicted))