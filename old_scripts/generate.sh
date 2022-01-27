#!/bin/bash

# generate plan for robot/order with id = 1
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=1 -c oid=1 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r1.lp

# generate plan for robot/order with id = 2
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=2 -c oid=2 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r2.lp

# generate plan for robot/order with id = 3
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=3 -c oid=3 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r3.lp

# generate plan for robot/order with id = 4
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=4 -c oid=4 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r4.lp

# generate plan for robot/order with id = 5
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=5 -c oid=5 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r5.lp

# generate plan for robot/order with id = 6
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=6 -c oid=6 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r6.lp

# generate plan for robot/order with id = 7
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=7 -c oid=7 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r7.lp

# generate plan for robot/order with id = 8
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=8 -c oid=8 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r8.lp

# generate plan for robot/order with id = 9
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=9 -c oid=9 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r9.lp

# generate plan for robot/order with id = 10
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=10 -c oid=10 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r10.lp

# generate plan for robot/order with id = 11
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=11 -c oid=11 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r11.lp

# generate plan for robot/order with id = 12
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 -c rid=12 -c oid=12 asprilo-encodings/modified_initial/encoding.lp instances/example3/instance.lp | head -n1 > instances/example3/plans/plan_r12.lp
