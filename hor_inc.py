#ADRIAN'S SCRIPT
import clingo
import sys
import time
import re
import multiprocessing

def reading(programs, instances):
	#Reading content of encoding
	encodings = open(programs, "r")
	encoding = encodings.read()
	encodings.close()

	#Reading content of instance
	benchmarks = open(instances, "r")
	instance = benchmarks.read()
	benchmarks.close()

	return encoding + instance, encoding, instance

def min_horizon(instance,programs,encoding):
	maxDist = 1
	robots = []
	splitinstance = instance.splitlines()
	for i in range(len(splitinstance)):
		if("% Robot" in splitinstance[i]):
			robots.append(i)

	combining = False		

	if("node combining" in programs):
		combining = True
		splitencoding = encoding.splitlines()
		x_size = re.findall(r'\d+', splitencoding[0])
		y_size = re.findall(r'\d+', splitencoding[1])
		

	for i in robots:
		r_num = re.findall(r'\d+', splitinstance[i+1])
		s_num = re.findall(r'\d+', splitinstance[i+2])
		x_dis = abs(int(r_num[1]) - int(s_num[1]))
		y_dis = abs(int(r_num[2]) - int(s_num[2]))
		if(combining):
			x_dis = int(x_dis/int(x_size[0]))
			y_dis = int(y_dis/int(y_size[0]))
		maxDist = max(maxDist, x_dis + y_dis)
	
	return maxDist

def node_count(instance):
	splitinstance = instance.splitlines()
	count = 0
	for i in splitinstance:
		if "node" in i and not "%" in i:
			count = count + 1
	return count

def solving(combined,i,nodecount):
	start = time.time()
	solution = ""
	while(not solution and i<nodecount):
		#print("Testing Horizon: " + str(i)) MODIFIED
		#ASP encoding
		horizon = "#const horizon = {}.".format(i)
		asp = horizon + "\n" + combined
		#Starting clingo solving
		ctl = clingo.Control()
		ctl.add("base", [], asp)
		ctl.ground([("base", [])])
		with ctl.solve(yield_=True) as handle:
			for m in handle:
				solution = str(m)
				solution = solution.replace(" ", ". ")
				solution = solution + "."
				break
		i = i + 1
		
	end = time.time()
	if(solution):
		print(solution)
	else:
		print("UNSATISFIABLE")
	#print("Solution time: " + str(end - start) + "s") MODIFIED	




if __name__ == '__main__':
	#Encoding and instance as system argument
	combined,encoding,instance = reading(sys.argv[1],sys.argv[2])
	
	# Starting horizon
	maxDist = min_horizon(instance, sys.argv[1], encoding)
	
	nodes = node_count(instance)
	
	p = multiprocessing.Process(target=solving, name="Solving", args=(combined,maxDist,nodes))
	p.start()
	p.join(180)
	if p.is_alive():
		p.terminate()
		p.join()
		print("Timeout")


