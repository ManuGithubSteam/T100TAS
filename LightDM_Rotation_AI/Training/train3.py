#!/usr/bin/python3

#The MIT License (MIT)
#Copyright (c) 2016 Stefan Möbius and Manuel Soukup

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import numpy
import random
import pprint
import math

LEARNING_RATE = 0.1

def calc(inp):
	out = numpy.empty(weights.shape[0])
	for i in range(weights.shape[0]):
		res = 0.0
		for j in range(weights.shape[1]):
				res += weights[i][j][int((numpy.sign(inp[j])+1)/2)] * inp[j]
		if res > 1.0:
			res = 1.0
		if res < 0.0:
			res = 0.0
		out[i] = res
	return out
									
def train(inp, out, label):
	for i in range(weights.shape[0]):
		d = (label[i] - out[i]) * LEARNING_RATE		
		for j in range(weights.shape[1]):			
			weights[i][j][int((numpy.sign(inp[j])+1)/2)] += d * inp[j]
		
		
weights = numpy.random.rand(4, 4, 2) #num ouputs, num inputs, weights for neg and pos inputs
          
                  
file = open("/home/benutzer/data5.txt", "r")
lines = file.readlines()
file.close()
	
for repeats in range(5000000):
	line = lines[int(random.random() * (len(lines)-1))]
	
	if line.strip() <> "":
		data = map(int, line.split(" "))
		inp = data[:4] # x, y, z and 1 as inputs
		#inp = numpy.divide(numpy.array(inp),16000.0)
		inp[0] /= 16000.0
		inp[1] /= 16000.0
		inp[2] /= 16000.0						
		label = numpy.array(map(int, '{0:b}'.format(16+data[4])[1::])) # label to binary array
		out = calc(inp)				
		train(inp, out, label)
		#print(2**(3-maxidx))
		#print(data[4])
		
		LEARNING_RATE *= 0.9999
		if LEARNING_RATE < 0.0001:
			LEARNING_RATE = 0.0001
		if repeats % 1000 == 0:
			print(numpy.linalg.norm(out-label))
		#print(out)
		#print(label)
			
pprint.pprint(weights)

