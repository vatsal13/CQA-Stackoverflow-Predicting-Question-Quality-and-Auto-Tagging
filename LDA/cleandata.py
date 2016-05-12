__author__ = 'Tejal'


import csv
import nltk
from nltk.corpus import stopwords
import numpy as np
import string
import re
import lda


dict = {"":{0:0}}
f = open('post1606.csv', 'rb')
reader = csv.reader(f)
titles = []
# reader has 3 columns and number of rows is equal to the number of questions
for row in reader:
    # row[0] has an id for each question
    row[0] = int(row[0])
    titles.append(row[0])
    # merging title and body of question into row[1]
    row[1] = row[1]+row[2]
    # removing html tags from row[1]
    row[1] = re.sub('<[^<]+?>', '', row[1])
    # setting row[2] to a list of tokens
    row[2] = nltk.word_tokenize(row[1].lower().translate(None, string.punctuation))
    # removing stop words from tokens
    row[2] = [w for w in row[2] if not w in stopwords.words('english')]
    # print row[2]
    # find the number of times each word occurs in each document
    for token in row[2]:
        if token in dict:
            # check if entry for question exists
            if row[0] in dict[token]:
                # update existing entry
                dict[token][row[0]] = dict[token][row[0]] + 1
            else:
                # create entry for the question
                dict[token].update({row[0]:1})
        else:
            # create entry for the word and the question
            dict.update({token:{row[0]:1}})
vocab = (dict.keys())
vocab = tuple(vocab)
titles = tuple(titles)
# print dict
# print titles
# print vocab
f.close()

ndarray = np.array([[]])
nestedlist = []
j=0
for word in vocab:
    if word != "":
        # print("word:")
        # print(word)
        i=0
        rowlist = []
        for title in titles:
            # print("title:")
            # print(title)
            if title in dict[word].keys():
                rowlist.insert(i,dict[word][title])
            else:
                rowlist.insert(i,0)
            i=i+1
        nestedlist.insert(j,rowlist)
        j = j+1
ndarray = np.array(nestedlist)
print(ndarray)
print(vocab.__len__())
print(titles.__len__())
print(ndarray.shape)

model = lda.LDA(n_topics=10, n_iter=1500, random_state=1)
model.fit(ndarray.T)  # model.fit_transform(X) is also available
doc_topic = model.doc_topic_  # model.components_ also works
# n_top_words = 8
# for i, topic_dist in enumerate(topic_word):
#     topic_words = np.array(vocab)[np.argsort(topic_dist)][:-(n_top_words+1):-1]
#     print('Topic {}: {}'.format(i, ' '.join(topic_words)))
# for prob in doc_topic:
#     prob = round(prob,5)
print(doc_topic.shape)
print(doc_topic)
np.savetxt("doctopic1606.csv",doc_topic, delimiter=',')
# np.savetxt("posts100.txt", ndarray, delimiter=',')