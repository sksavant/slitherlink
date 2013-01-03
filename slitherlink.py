#!/usr/bin/python

import sys
import os

out = open("predicates.txt", 'w')
with open(sys.argv[1],'r') as f:
	line = f.readline()
	head = line.replace('\r','').replace('\n','').split()
	m = int(head[0])
	n = int(head[1])
	out.write('loop :- solve({0},{1},\n'.format(m,n))

	out.write('[')
	for i in range(1, m + 2):
		for j in range(1, n + 2):
			if i == m + 1 and j == n + 1:
				out.write('dot({0},{1})'.format(i,j))
			else:
				out.write('dot({0},{1}),\n'.format(i,j))


	out.write('],\n[')
	for i in range(1, m + 1):
		line = f.readline()
		clues = line.replace('\r','').replace('\n','').split()
		#~ print clues
		for j in range(1, n + 1):
			if i == m and j == n:
				out.write('clue({0},{1},{2})'.format(i,j,clues[j - 1]))
			else:
				out.write('clue({0},{1},{2}),\n'.format(i,j,clues[j - 1]))

	out.write('],\n[')

	for i in range(1, m + 2):
		for j in range(1, n + 2):
			for k in range(1,5):
				if i > 1 or k != 4:
					if j > 1 or k != 3:
						if i < m + 1 or k != 2:
							if j < n + 1 or k != 1:
								if i == m + 1 and j == n + 1 and k == 4:
									out.write('edge({0},{1},{2},_)'.format(i,j,k))
								else:
									out.write('edge({0},{1},{2},_),\n'.format(i,j,k))

	out.write(']), halt.')

out.close()

os.system('cp slitherlink_program.pl slitherRun.pl')

with open('slitherRun.pl', 'a') as prog:
	with open('predicates.txt','r') as pred:
		for line in pred:
			prog.write(line)

print "Solving the puzzle..! This may take few minutes. Please wait...."
os.system('swipl -q -t loop -s slitherRun.pl > output.txt')

print ""

with open('output.txt', 'r') as f:
	with open(sys.argv[1], 'r') as ip:
		s = f.readline()
		out = ""

		line = ip.readline()

		for i in range(1, m + 2):
			line = ip.readline()
			clues = line.replace('\r','').replace('\n','').split()
			clues = map(lambda x: ' ' if int(x) == -1 else x, clues)
			for j in range(1, n + 2):
				if s.find('edge({0},{1},1,1)'.format(i,j)) != -1:
					out += "+---"
				else:
					out += "+   "
			print out
			out = ""
			for j in range(1, n + 2):
				if j < n + 1 and i < m + 1:
					if s.find('edge({0},{1},2,1)'.format(i,j)) != -1:
						out += "| {0} ".format(clues[j - 1])
					else:
						out += "  {0} ".format(clues[j - 1])
				else:
					if s.find('edge({0},{1},2,1)'.format(i,j)) != -1:
						out += "|   "
					else:
						out += "    "
			print out
			out = ""



#os.system('rm -f predicates.txt output.txt  slitherRun.pl')


