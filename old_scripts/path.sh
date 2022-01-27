#!/bin/bash

clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=6 -c rid=1 asprilo-encodings/shortest_path/pathfinder.lp instances/abstraction1/instance.lp | head -n1 > instances/abstraction1/plan.lp

#clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=4 asprilo-encodings/shortest_path/pathfinder.lp instances/abstraction1/instance.lp | head -n1 > instances/abstraction1/plan.lp
