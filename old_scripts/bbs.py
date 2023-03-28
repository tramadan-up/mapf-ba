import clingo
import re
import sys
import os
from json import dumps
import argparse
import glob
from multiprocessing import Process, RawArray, Value, Array, Lock
import ctypes

# combines n text files and saves it in a new file under the destination_path
def combine_files(filenames, destination_path):
	if os.path.exists(destination_path):
		os.remove(destination_path)	
	with open(destination_path, "w") as file_out:
		for f in filenames:
			with open(f) as file_in:
					file_out.write(file_in.read())

# combines the content of two text files and saves it in a new file under the destination_path
def combine(first_path, second_path, destination_path):
	first_file = open(first_path, "r")
	first = first_file.read()
	first_file.close()

	second_file = open(second_path, "r")
	second = second_file.read()
	second_file.close()

	if os.path.exists(destination_path):
		os.remove(destination_path)
	destination_file = open(destination_path, "w")
	destination = destination_file.write(first + second)
	destination_file.close()

# saves the given solution under the destination_path
def save(solution, destination_path):
	if os.path.exists(destination_path):
		os.remove(destination_path)
	file = open(destination_path, "w")
	file.write(solution)
	file.close()

# saves a list of solutions under the destination_path
def save_plans(plans, destination_path):
	if os.path.exists(destination_path):
		os.remove(destination_path)
	file = open(destination_path, "w")
	for i in range(len(plans)):
		file.write(plans[i])
	file.close()

# preparation of the abstraction
def prep(destination_path, time, solve):
	destination_file = open(destination_path, "r")
	destination = destination_file.read()
	destination_file.close()

	solution = ""
	man_dis=[]
	robots=[]
	asp=destination

	ctl = clingo.Control(['--stats'])
	ctl.add("base", [], asp)
	ctl.ground([("base", [])])
	with ctl.solve(yield_=True) as handle:
		for m in handle:
			solution=("{} ".format(m))
			man_dis=re.findall('md(.+?) ', ("{} ".format(m)))
			robots=re.findall('rbt(.+?) ', ("{} ".format(m)))
		handle.get()
		solution = solution.replace(') ', '). ')
	time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
	solve.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
	return solution, robots, man_dis, time, solve

# planning
def plan(plan_, robot_id, man_dis, destination_path, time, solve):
	destination_file = open(destination_path, "r")
	destination = destination_file.read()
	destination_file.close()
	solution = ""

	rid = "#const rid = {}.".format(robot_id)
	for i in range(man_dis,man_dis*2):
		horizon = "#const horizon = {}.".format(i)
		asp = destination + rid + horizon
		ctl = clingo.Control(['--stats'])
		ctl.add("base", [], asp)
		ctl.ground([("base", [])])
		symbolic_atoms = ctl.symbolic_atoms
		#print(symbolic_atoms)
		#print(str(atom) for atom in symbolic_atoms)
		with ctl.solve(yield_=True) as handle:
			for m in handle:
				solution = ("{} ".format(m))
			handle.get()
			solution = solution.replace(') ', '). ')
		if solution:
			time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
			solve.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
			plan_.append(solution)
			break
	return plan_, time, solve

def plan_parallel(plan_, robot_id, man_dis, destination_path, time, solve, lock):
	destination_file = open(destination_path, "r")
	destination = destination_file.read()
	destination_file.close()
	solution = ""

	rid = "#const rid = {}.".format(robot_id)
	for i in range(man_dis,man_dis*2):
		horizon = "#const horizon = {}.".format(i)
		asp = destination + rid + horizon
		ctl = clingo.Control(['--stats'])
		ctl.add("base", [], asp)
		ctl.ground([("base", [])])
		symbolic_atoms = ctl.symbolic_atoms
		#print(symbolic_atoms)
		#print(str(atom) for atom in symbolic_atoms)
		with ctl.solve(yield_=True) as handle:
			for m in handle:
				solution = ("{} ".format(m))
			handle.get()
			solution = solution.replace(') ', '). ')
		if solution:
			with lock:
				time.value += float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': ')))
				solve.value += float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': ')))
			plan_.append(solution)
			break
	return plan_, time, solve



# detect collisions (and evaluate them, giving each contraint a score)
def collision(constraints, destination_path, time, solve):
	destination_file = open(destination_path, "r")
	destination = destination_file.read()
	destination_file.close()
	solution = ""
	robots_c=[]
	asp=destination
	ctl = clingo.Control(['--stats'])
	ctl.add("base", [], asp)
	ctl.ground([("base", [])])
	with ctl.solve(yield_=True) as handle:
		for m in handle:
			robots_c=re.findall('robot_c(.+?) ', ("{} ".format(m)))
			con=re.findall(r"constraint\(\((\d+),(\d+)\),(\d+),(\d+)\)", ("{} ".format(m)))
			solution = ("{} ".format(m))
		handle.get()
		solution = solution.replace(') ', '). ')
	if solution:
		time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
		solve.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
		for c in con:
			x, y, r, t = map(int, c)
			constraints.append(f"constraint(({x},{y}),{r},{t}). ")
		#if solution!=" ":
		#	constraints.append(solution)
	return constraints, robots_c, time, solve

def replan_robot(element, man_dis, destination_path, time_, solve_, lock):
	plans=[]
	file_name = "./solution/single/file_{}.lp".format(element)
	plans, time_, solve_ = plan_parallel(plans, element, man_dis, destination_path, time_, solve_, lock)
	if plans:
		save_plans(plans, file_name)
	robots_c.remove(element)


def replan_parallel(robots_c, man_dis, destination_path, time, solve):
	time_ = Value('d',0)
	solve_ = Value('d',0)
	processes=[]
	lock = Lock()
	for r in robots_c:
		p = Process(target=replan_robot, args=(r,man_dis,destination_path,time_,solve_,lock))
		processes.append(p)
		p.start()

	for p in processes:
		p.join()
	#with Pool() as pool:
	#	pool.starmap(replan_robot, [(element, man_dis, destination_path, time_, solve_) for element in robots_c])
	time.append(time_.value)
	solve.append(solve_.value)
	return robots_c, time, solve

# 
def replan_serial(robots_c, man_dis, destination_path, time, solve):
	while robots_c:
		process_robots(robots_c, man_dis, destination_path, time, solve)
	return robots_c, time, solve

def process_robots(robots_c, man_dis, destination_path, time, solve):
	while robots_c:
		robot_id=robots_c.pop(0)
		plans=[]
		file_name = "./solution/single/file_{}.lp".format(robot_id)
		plans, time, solve = plan(plans, robot_id, man_dis, destination_path, time, solve)
		"""
		print("Plan")
		print("Grounding: " + str(sum(time)-sum(solve)))
		print("Solving: " + str(sum(solve)))
		print("Total: " + str(sum(time)))
		"""
		if plans:
			save_plans(plans, file_name)
	return robots_c, time, solve



parser = argparse.ArgumentParser()
parser.add_argument("instance", help="benchmarkfile")
args = parser.parse_args()


enc1 = "./asprilo-encodings/single/path.lp"									  # pathfinding encoding
enc2 = "./asprilo-encodings/prep/single.lp"				  # preparation encoding
dest1 = "./solution/single/combined_instance.lp"			 # temporary file: instance
dest2 = "./solution/single/combined_prep.lp"				 # temporary file: preparation
dest3 = "./solution/single/prep.lp"						  # processed instance
col = "./asprilo-encodings/single/collision.lp"			  # collision encoding
dest4 = "./solution/single/collisions.lp"						  # solution
dest5 = "./solution/single/combined_plans.lp"
dest6 = "./solution/single/combined_collision.lp"
dest7 = "./solution/single/prep_c.lp"
files=[enc1,dest4,dest3]
abst = args.instance															# user input - instance/abstraction

time=[]
solve=[]
#robots=[]
md=[]																		   # manhattan distances
constraints=[]
parallel=True

combine(enc2,abst,dest2)														# combine preparation encoding with abstarction
prep_, robots, man_dis, time, solve = prep(dest2, time, solve)				  # perform preparation on combined files, extract solution, grouping, manhattan distances and time
"""
print("Prep")
print("Grounding: " + str(sum(time)-sum(solve)))
print("Solving: " + str(sum(solve)))
print("Total: " + str(sum(time)))
"""
save(prep_,dest3)															   # save solution for further usage
combine(enc1,dest3,dest1)													   # combine pathfinding encoding with prepared abstraction


for i in range(len(robots)):
	robots[i] = int(robots[i].strip('()'))					  # process information on grouping

for i in range(len(man_dis)):
	x,y = map(int, man_dis[i].strip('()').split(','))		   # process information on manhattan distances
	md.append(y)
max_md = max(md)												# determine highest manhattan distance


for i in robots:
	plans=[]
	file_name = "./solution/single/file_{}.lp".format(i)
	plans, time, solve = plan(plans, i, max_md, dest1, time, solve)
	"""
	print("Plan")
	print("Grounding: " + str(sum(time)-sum(solve)))
	print("Solving: " + str(sum(solve)))
	print("Total: " + str(sum(time)))
	"""
	if plans:
		save_plans(plans, file_name)

filenames = glob.glob("./solution/single/file_*.lp")

combine_files(filenames, dest5)
combine(col,dest5,dest6)
constraints, robots_c, time, solve = collision(constraints, dest6, time, solve)
"""
print("Con")
print("Grounding: " + str(sum(time)-sum(solve)))
print("Solving: " + str(sum(solve)))
print("Total: " + str(sum(time)))
"""
save_plans(constraints,dest4)
for i in range(len(robots_c)):
	robots_c[i] = int(robots_c[i].strip('()'))
combine_files(files, dest1)

while robots_c:
	if parallel:
		robots_c, time, solve = replan_parallel(robots_c, max_md, dest1, time, solve)
	else:
		robots_c, time, solve = replan_serial(robots_c, max_md, dest1, time, solve)
	#print("Total: " + str(sum(time)))
	filenames = glob.glob("./solution/single/file_*.lp")
	combine_files(filenames, dest5)
	combine(col,dest5,dest6)
	constraints, robots_c, time, solve = collision(constraints, dest6, time, solve)
	"""
	print("Con")
	print("Grounding: " + str(sum(time)-sum(solve)))
	print("Solving: " + str(sum(solve)))
	print("Total: " + str(sum(time)))
	"""
	save_plans(constraints,dest4)
	for i in range(len(robots_c)):
		robots_c[i] = int(robots_c[i].strip('()'))
	combine_files(files, dest1)


print("End")
print("Grounding: " + str(sum(time)-sum(solve)))
print("Solving: " + str(sum(solve)))
print("Total: " + str(sum(time)))

"""
try:																			# delete temporary files
	os.remove(dest1)
	os.remove(dest2)
	os.remove(dest4)
	os.remove(dest6)
	os.remove(dest7)
except OSError as e:
	print("Error: %s : %s" % (dest1, e.strerror))
	print("Error: %s : %s" % (dest2, e.strerror))
	print("Error: %s : %s" % (dest4, e.strerror))
	print("Error: %s : %s" % (dest6, e.strerror))
	print("Error: %s : %s" % (dest7, e.strerror))
"""