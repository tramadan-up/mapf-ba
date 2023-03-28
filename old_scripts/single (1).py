# solves the instance for a robot at a time
def solve(robot_id, man_dis, destination_path, time, solve_, restrictions=[]):
##########
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
##########

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
