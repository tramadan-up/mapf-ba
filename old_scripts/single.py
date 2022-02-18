import clingo
import re
import sys
import os
from json import dumps

# combines the content of two text files and saves it in a new file under the destination_path
def combine(encoding_path, benchmark_path, destination_path):
    combined_path = destination_path

    encoding_file = open(encoding_path, "r")
    encoding = encoding_file.read()
    encoding_file.close()

    benchmark_file = open(benchmark_path, "r")
    benchmark = benchmark_file.read()
    benchmark_file.close()

    combined_file = open(combined_path, "w")
    combined = combined_file.write(benchmark + encoding)
    combined_file.close()

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

# solves the instance for a robot at a time
def solve(robot_id, man_dis, destination_path, time, solve_, restrictions=[]):
    combined_path = destination_path
    combined_file = open(combined_path, "r")
    combined = combined_file.read()
    combined_file.close()
    rid = "#const rid = {}.".format(robot_id)
    md=man_dis
    if md==0:
        while md==0:
            solution = ""
            horizon = "#const horizon = {}.".format(md)
            asp = horizon + "\n" + rid + "\n" + combined
            if restrictions:
                for j in restrictions:
                    if j:
                        asp = asp + "\n" + j

            ctl = clingo.Control(['--stats'])
            ctl.add("base", [], asp)
            ctl.ground([("base", [])])
            with ctl.solve(yield_=True) as handle:
                for m in handle: solution=("{} ".format(m))
                handle.get()
            time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
            solve_.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
            solution = solution.replace(' ', '. ')
            md=md+1
            if solution:
                return solution, md, time, solve_
                break

    for i in range(md,md*2):
        solution = ""
        horizon = "#const horizon = {}.".format(i)
        asp = horizon + "\n" + rid + "\n" + combined
        if restrictions:
            for j in restrictions:
                if j:
                    asp = asp + "\n" + j
        ctl = clingo.Control(['--stats'])
        ctl.add("base", [], asp)
        ctl.ground([("base", [])])
        with ctl.solve(yield_=True) as handle:
            for m in handle: solution=("{} ".format(m))
            handle.get()
        time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
        solve_.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
        solution = solution.replace(' ', '. ')
        if solution:
            return solution, i, time, solve_
            break

# preparation of the abstraction
def prep(destination_path, time, solve_):
    combined_path = destination_path
    combined_file = open(combined_path, "r")
    combined = combined_file.read()
    combined_file.close()

    solution = ""
    md=[]
    r=[]
    asp=combined

    ctl = clingo.Control(['--stats'])
    ctl.add("base", [], asp)
    ctl.ground([("base", [])])
    with ctl.solve(yield_=True) as handle:
        for m in handle:
            solution=("{} ".format(m))
            md=re.findall('md(.+?) ', ("{} ".format(m)))
            r=re.findall('rbt(.+?) ', ("{} ".format(m)))
        handle.get()
        solution = solution.replace(' ', '. ')
    time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
    solve_.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
    return solution, r, md, time, solve_

# preplanning
def preplan(robots, man_dis, destination, time, solve_, restrictions=[]):
    plans=[]
    plan_=""
    paths = []
    actions = []

    if not paths:
        for i in robots:
            paths.append([])

    for i in robots:
        temp = solve(i, man_dis, destination, time, solve_, restrictions)
        paths[i-1].append(temp[0])
        actions.append(temp[1])
        time = temp[2]
        solve_ = temp[3]
        if paths[i-1][0]:
            plan_ = plan_ + paths[i-1][0]
    return paths, plan_, actions, time, solve_

# detect collisions
def collisions(robot_id, encoding_path, plan, time, solve_):

    encoding_file = open(encoding_path, "r")
    encoding = encoding_file.read()
    encoding_file.close()

    rid = "#const rid = {}.".format(robot_id)
    asp = rid + "\n" + plan + "\n" + encoding
    solution_ = ""
    li = []

    ctl = clingo.Control(['--stats'])
    ctl.add("base", [], asp)
    ctl.ground([("base", [])])
    with ctl.solve(yield_=True) as handle:
        for m in handle:
            solution_=("{} ".format(m))
            li = re.findall('s\((.+?),',("{} ".format(m)))
        handle.get()
    time.append(float(dumps(ctl.statistics['summary']['times']['total'], sort_keys=True, indent=4, separators=(',', ': '))))
    solve_.append(float(dumps(ctl.statistics['summary']['times']['solve'], sort_keys=True, indent=4, separators=(',', ': '))))
    li=list(set(map(int,li)))
    if solution_== " ":
        return
    else:
        solution_ = solution_.replace(' ', '. ')

        return solution_, li, time, solve_

# planning
def plan(robots, destination, collision, paths, plan_, actions, time, solve_, restrictions=[]):
    max_value = max(actions)
    max_index = actions.index(max_value)
    cur_rest = []
    temp_ = collisions(actions[max_index], collision, plan_, time, solve_)
    if temp_:
        cur_rest.append(temp_[0])
        time=temp_[2]
        solve_=temp_[3]
    if cur_rest:
        restrictions.append(cur_rest[-1])
        restricted_robots = temp_[1]
        for i in restricted_robots:
            temp = solve(i, max_value, destination, time, solve_, restrictions)
            if temp:
                paths[i-1] = [temp[0]]
                actions[i-1] = temp[1]
                time = temp[2]
                solve_ = temp[3]
        plan_ = ""
        for i in robots:
            if paths[i-1][0]:
                plan_ = plan_ + paths[i-1][0]
        plan_, time, solve_ = plan(robots, destination, collision, paths, plan_, actions, time, solve_, restrictions)
    return plan_, time, solve_

enc1 = "./asprilo-encodings/single/path.lp"                  # pathfinding encoding
enc2 = "./asprilo-encodings/prep/single.lp"                  # preparation encoding
ben = sys.argv[1]                                               # user input - instance/abstraction
dest1 = "./solution/single/combined_instance.lp"             # temporary file: instance
dest2 = "./solution/single/combined_prep.lp"                 # temporary file: preparation
dest3 = "./solution/single/prep.lp"                          # processed instance
col = "./asprilo-encodings/single/collision.lp"              # collision encoding
dest4 = "./solution/single/plan.lp"                          # solution

time=[]
solve_=[]
rest=[]
md=[]                                                           # manhattan distances

combine(enc2, ben, dest2)                                       # combine preparation encoding with abstarction
prep_, robots, man_dis, time, solve_ = prep(dest2, time, solve_)                # perform preparation on combined files, extract solution, grouping, manhattan distances and time
save(prep_,dest3)                                               # save solution for further usage
combine(enc1,dest3,dest1)                                       # combine pathfinding encoding with prepared abstraction

for i in range(len(robots)):
    robots[i] = int(robots[i].strip('()'))                      # process information on grouping

for i in range(len(man_dis)):
    x,y = map(int, man_dis[i].strip('()').split(','))           # process information on manhattan distances
    md.append(y)
max_md = max(md)                                                # determine highest manhattan distance

paths, plan_, actions, time, solve_ = preplan(robots, max_md, dest1, time, solve_, rest)    # generate a plan for each robot
plans, time, solve_ = plan(robots, dest1, col, paths, plan_, actions, time, solve_, rest)   # replan colliding robots until solution
save_plans(plans, dest4)                                        # save plans

print("Grounding: " + str(sum(time)-sum(solve_)))
print("Solving: " + str(sum(solve_)))
print("Total: " + str(sum(time)))

try:                                                            # delete temporary files
    os.remove(dest1)
    os.remove(dest2)
except OSError as e:
    print("Error: %s : %s" % (dest1, e.strerror))
    print("Error: %s : %s" % (dest2, e.strerror))
