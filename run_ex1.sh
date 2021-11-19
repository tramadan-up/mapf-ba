#!/bin/bash


# extract instance 
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 asprilo-encodings/modified/extract_instance.lp instances/example1/plans/{plan_r1.lp,plan_r2.lp} | head -n1 > instances/example1/instance_ex.lp

# modify instance
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 asprilo-encodings/modified/modify_instance.lp instances/example1/instance_ex.lp | head -n1 > instances/example1/instance_mod.lp

# plan on modified instance
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=5 asprilo-encodings/modified/encoding.lp instances/example1/instance_mod.lp | head -n1 > instances/example1/plan.lp

# visualize generated instance + plan
viz -t instances/example1/instance_mod.lp instances/example1/plan.lp
