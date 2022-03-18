import clingo
import re
import sys
import os
from json import dumps
import argparse

# combines the content of two text files and saves it in a new file under the destination_path
def combine(first_path, second_path, destination_path):
    first_file = open(first_path, "r")
    first = first_file.read()
    first_file.close()

    second_file = open(second_path, "r")
    second = second_file.read()
    second_file.close()

    destination_file = open(destination_path, "w")
    destination = destination_file.write(first + second)
    destination_file.close()

# saves the given solution under the destination_path
def save(solution, destination_path):
    file = open(destination_path, "w")
    file.write(solution)
    file.close()

# saves a list of solutions under the destination_path
def save_plans(plans, destination_path):
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
    md=[]
    gr=[]
    asp=destination

    ctl = clingo.Control(['--stats'])
    ctl.add("base", [], asp)
    ctl.ground([("base", [])])
    with ctl.solve(yield_=True) as handle:
        for m in handle:
            solution=("{} ".format(m))
            md=re.findall('md(.+?) ', ("{} ".format(m)))
            gr=re.findall('group(.+?) ', ("{} ".format(m)))
        handle.get()
        solution = solution.replace(' ', '. ')
    time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
    solve.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
    return solution, gr, md, time, solve

# planning
def plan(plan, groups, man_dis, destination_path, time, solve):
    destination_file = open(destination_path, "r")
    destination = destination_file.read()
    destination_file.close()


    for i in groups:
        solution = ""
        asp = ""
        grp = "#const grp = {}.".format(i)
        asp = destination + grp
        for j in range(man_dis,man_dis*2):
            horizon = "#const horizon = {}.".format(j)
            asp = destination + grp + horizon
            ctl = clingo.Control(['--stats'])
            ctl.add("base", [], asp)
            ctl.ground([("base", [])])
            with ctl.solve(yield_=True) as handle:
                for m in handle:
                    solution = ("{} ".format(m))
                handle.get()
                solution = solution.replace(' ', '. ')
            if solution:
                time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
                solve.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
                plans.append(solution)
                break
    return plans, time, solve


parser = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group()
group.add_argument("-nc", "--nodecombining", action="store_true")
group.add_argument("-sp", "--shortestpath", action="store_true")
group.add_argument("-rn", "--reachablenodes", action="store_true")
group.add_argument("-cnc", "--c_nodecombining", action="store_true")
group.add_argument("-csp", "--c_shortestpath", action="store_true")
group.add_argument("-crn", "--c_reachablenodes", action="store_true")
parser.add_argument("instance", help="benchmarkfile")
args = parser.parse_args()

if args.nodecombining:
    #
    enc2 = "./asprilo-encodings/prep/nc.lp"                                     # preparation encoding
    dest1 = "./solution/group_nc/combined_instance.lp"                          # temporary file: instance
    dest2 = "./solution/group_nc/combined_prep.lp"                              # temporary file: preparation
    dest3 = "./solution/group_nc/prep.lp"                                       # processed instance
    dest4 = "./solution/group_nc/plan.lp"                                       # solution
elif args.shortestpath:
    #
    enc2 = "./asprilo-encodings/prep/sp.lp"                                     # preparation encoding
    dest1 = "./solution/group_sp/combined_instance.lp"                          # temporary file: instance
    dest2 = "./solution/group_sp/combined_prep.lp"                              # temporary file: preparation
    dest3 = "./solution/group_sp/prep.lp"                                       # processed instance
    dest4 = "./solution/group_sp/plan.lp"                                       # solution
elif args.reachablenodes:
    #
    enc2 = "./asprilo-encodings/prep/rn.lp"                                     # preparation encoding
    dest1 = "./solution/group_rn/combined_instance.lp"                          # temporary file: instance
    dest2 = "./solution/group_rn/combined_prep.lp"                              # temporary file: preparation
    dest3 = "./solution/group_rn/prep.lp"                                       # processed instance
    dest4 = "./solution/group_rn/plan.lp"                                       # solution
elif args.c_nodecombining:
    #
    enc2 = "./asprilo-encodings/prep/collisions/nc.lp"                           # preparation encoding
    dest1 = "./solution/group_c_nc/combined_instance.lp"                        # temporary file: instance
    dest2 = "./solution/group_c_nc/combined_prep.lp"                            # temporary file: preparation
    dest3 = "./solution/group_c_nc/prep.lp"                                     # processed instance
    dest4 = "./solution/group_c_nc/plan.lp"                                     # solution
elif args.c_shortestpath:
    #
    enc2 = "./asprilo-encodings/prep/collisions/sp.lp"                           # preparation encoding
    dest1 = "./solution/group_c_sp/combined_instance.lp"                        # temporary file: instance
    dest2 = "./solution/group_c_sp/combined_prep.lp"                            # temporary file: preparation
    dest3 = "./solution/group_c_sp/prep.lp"                                     # processed instance
    dest4 = "./solution/group_c_sp/plan.lp"                                     # solution
elif args.c_reachablenodes:
    #
    enc2 = "./asprilo-encodings/prep/collisions/rn.lp"                           # preparation encoding
    dest1 = "./solution/group_c_rn/combined_instance.lp"                        # temporary file: instance
    dest2 = "./solution/group_c_rn/combined_prep.lp"                            # temporary file: preparation
    dest3 = "./solution/group_c_rn/prep.lp"                                     # processed instance
    dest4 = "./solution/group_c_rn/plan.lp"                                     # solution
else:
    #all_cnc
    enc2 = "./asprilo-encodings/prep/all.lp"                                    # preparation encoding
    dest1 = "./solution/group_a_nc/combined_instance.lp"                        # temporary file: instance
    dest2 = "./solution/group_a_nc/combined_prep.lp"                            # temporary file: preparation
    dest3 = "./solution/group_a_nc/prep.lp"                                     # processed instance
    dest4 = "./solution/group_a_nc/plan.lp"                                     # solution




enc1 = "./asprilo-encodings/group/path.lp"                                      # pathfinding encoding
abst = args.instance                                                            # user input - instance/abstraction

time=[]
solve=[]
plans=[]
md=[]                                                                           # manhattan distances

combine(enc2,abst,dest2)                                                        # combine preparation encoding with abstarction
prep_, groups, man_dis, time, solve = prep(dest2, time, solve)                  # perform preparation on combined files, extract solution, grouping, manhattan distances and time
#print(prep_)
save(prep_,dest3)                                                               # save solution for further usage
combine(enc1,dest3,dest1)                                                       # combine pathfinding encoding with prepared abstraction


for i in range(len(groups)):
    groups[i] = int(groups[i].strip('()'))                                      # process information on grouping

for i in range(len(man_dis)):
    x,y = map(int, man_dis[i].strip('()').split(','))                           # process information on manhattan distances
    md.append(y)
max_md = max(md)                                                                # determine highest manhattan distance

plans, time, solve = plan(plans, groups, max_md, dest1, time, solve)            # plan
if plans:
	save_plans(plans, dest4)     
else:
	save_plans(prep_, dest4)                                                   	# save plans

print("Grounding: " + str(sum(time)-sum(solve)))
print("Solving: " + str(sum(solve)))
print("Total: " + str(sum(time)))

try:                                                                            # delete temporary files
    os.remove(dest1)
    os.remove(dest2)
except OSError as e:
    print("Error: %s : %s" % (dest1, e.strerror))
    print("Error: %s : %s" % (dest2, e.strerror))

