import pyprind
import pandas as pd
import os
import numpy as np
import re
from nltk.stem.porter import PorterStemmer
import nltk
nltk.download('stopwords')

def preprocessor(text):
	text = re.sub('<[^>]*>', '', text)
	emoticons = re.findall('(?::|;|=)(?:-)?(?:\)|\(|D|P)', text)
	text = re.sub('[\W]+', ' ', text.lower()) + ''.join(emoticons).replace('-', '')
	return text

def tokenizer(text):
	return text.split()

def tokenizer_porter(text):
	return [porter.stem(word) for word in text.split()]

# change the `basepath` to the directory of the
# unzipped movie dataset

#basepath = '/Users/Sebastian/Desktop/aclImdb/'
# basepath = './aclImdb'

# labels = {'pos': 1, 'neg': 0}
pbar = pyprind.ProgBar(50000)
df = pd.DataFrame()
# for s in ('test', 'train'):
#     for l in ('pos', 'neg'):
#         path = os.path.join(basepath, s, l)
#         for file in os.listdir(path):
#             with open(os.path.join(path, file), 'r') as infile:
#                 txt = infile.read()
#             df = df.append([[txt, labels[l]]], ignore_index=True)
#             pbar.update()
# df.columns = ['review', 'sentiment']

# np.random.seed(0)
# df = df.reindex(np.random.permutation(df.index))
# df.to_csv('./movie_data.csv', index=False)

df = pd.read_csv('./movie_data.csv')
print df.head(3)

#--------- BAG OF WORDS -----------

df['review'] = df['review'].apply(preprocessor)

from sklearn.feature_extraction.text import CountVectorizer
count = CountVectorizer()
docs = np.array([
'The sun is shining',
'The weather is sweet',
'The sun is shining and the weather is sweet'])
bag = count.fit_transform(docs)

#--------- STEM -------------------
porter = PorterStemmer()

print tokenizer_porter('runners like running and thus they run')

# ----------- STOP -------------
from nltk.corpus import stopwords
stop = stopwords.words('english')
a = [w for w in tokenizer_porter('a runner likes running and runs alot')[-10:] if w not in stop]
print a

#------------ Logistic Regression -----------------

X_train = df.loc[:25000, 'review'].values
y_train = df.loc[:25000, 'sentiment'].values
X_test = df.loc[25000:, 'review'].values
y_test = df.loc[25000:, 'sentiment'].values

from sklearn.grid_search import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.feature_extraction.text import TfidfVectorizer
tfidf = TfidfVectorizer(strip_accents=None,lowercase=False,preprocessor=None)
param_grid = [{'vect__ngram_range': [(2,2)],
				'vect__stop_words': [stop, None],
				'vect__tokenizer': [tokenizer,tokenizer_porter],
				'clf__penalty': ['l1', 'l2'],
				'clf__C': [1.0, 10.0, 100.0]},
				{'vect__ngram_range': [(2,2)],
				'vect__stop_words': [stop, None],
				'vect__tokenizer': [tokenizer,tokenizer_porter],
				'vect__use_idf':[False],
				'vect__norm':[None],
				'clf__penalty': ['l1', 'l2'],
				'clf__C': [1.0, 10.0, 100.0]}]

lr_tfidf = Pipeline([('vect', tfidf),('clf',LogisticRegression(random_state=0))])
gs_lr_tfidf = GridSearchCV(lr_tfidf, param_grid, scoring='accuracy', cv=5, verbose=1, n_jobs=-1)
gs_lr_tfidf.fit(X_train, y_train)

print('Best parameter set: %s ' % gs_lr_tfidf.best_params_)
print('CV Accuracy: %.3f' % gs_lr_tfidf.best_score_)
clf = gs_lr_tfidf.best_estimator_
print('Test Accuracy: %.3f' % clf.score(X_test, y_test))