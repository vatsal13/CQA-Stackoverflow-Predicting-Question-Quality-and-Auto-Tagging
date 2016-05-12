
__author__ = 'Vatsal'

# Uses batch gradient descent
# Returns the weight vector

import math

def probNumerator(y, w, x, dimensions):
	sum = 0
	for i in range(0, dimensions):
		sum += w[y][i] * x[i]
	try:
		ans = math.exp(sum)
	except OverflowError:
		ans = float('inf') 
	return ans


def probDenominator(no_of_classes, w, x, dimensions):
	sum = 0
	for i in range(0, no_of_classes-1):
		sum += probNumerator(i, w, x, dimensions)
	try:
		denominator = 1 + math.exp(sum)
	except OverflowError:
		denominator = float('inf')
	return denominator


def prob(y, x, w, no_of_classes, dimensions):
	numerator = probNumerator(y, w, x, dimensions)
	denominator = probDenominator(no_of_classes, w, x, dimensions)

	if y == no_of_classes-1 :
		numerator = 1

	probability = numerator/float(denominator)

	return probability


def addBias(data):
	for i in range(0, len(data)):
		data[i].insert(0,1)
	return data


def intializeWeights(dimensions, no_of_classes):
	w = []

	for i in range(0, no_of_classes-1):
		a = [0 for j in range(0, dimensions)]
		w.append(a)
	return w


def gradientTerm(data, label, w, Class, dimension , no_of_classes, dimensions):
	sum = 0
	for i in range(0, len(data)):
		delta = 1 if label[i]==Class else 0
		probability = prob(Class, data[i], w, no_of_classes, dimensions)
		sum += data[i][dimension]*(delta - probability)
	
	return sum


def gradientAscent(w, no_of_classes, dimensions, data, label, iterations, learning_rate, regularization):
	w_update = w
	for it in range(0, iterations):
		for j in range(0, no_of_classes-1):
			for i in range(0, dimensions):
				w_update[j][i] = w[j][i] + learning_rate*(gradientTerm(data, label, w, j, i, no_of_classes, dimensions)) - learning_rate*regularization*w[j][i]  
		w = w_update
	
	return w


def logisticRegression(data, label, iterations, learning_rate, regularization, intial_weight = 'Null'):
	# label : array n x 1
	label_set = set(label)
	no_of_classes = len(label_set)
	length_of_data = len(data)
	data = addBias(data)
	dimensions = len(data[0])
	
	w = []
	if intial_weight == 'Null':
		w = intializeWeights(dimensions, no_of_classes)
	else:
		w = intial_weight

	final_weights = gradientAscent(w, no_of_classes, dimensions, data, label, iterations, learning_rate, regularization)

	return final_weights
