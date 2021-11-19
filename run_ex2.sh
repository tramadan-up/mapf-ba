#!/bin/bash

# extract instance 
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 asprilo-encodings/modified/extract_instance.lp instances/example2/plans/{plan_r1.lp,plan_r2.lp,plan_r3.lp,plan_r4.lp,plan_r5.lp,plan_r6.lp} | head -n1 > instances/example2/instance_ex.lp

# modify instance
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 asprilo-encodings/modified/modify_instance.lp instances/example2/instance_ex.lp | head -n1 > instances/example2/instance_mod.lp

# plan on modified instance
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=10 asprilo-encodings/modified/encoding.lp instances/example2/instance_mod.lp | head -n1 > instances/example2/plan.lp

# visualize generated instance + plan
viz -t instances/example2/instance_mod.lp instances/example2/plan.lp
