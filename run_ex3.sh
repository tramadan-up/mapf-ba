#!/bin/bash

# extract instance 
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 asprilo-encodings/modified/extract_instance.lp instances/example3/plans/{plan_r1.lp,plan_r2.lp,plan_r3.lp,plan_r4.lp,plan_r5.lp,plan_r6.lp,plan_r7.lp,plan_r8.lp,plan_r9.lp,plan_r10.lp,plan_r11.lp,plan_r12.lp} | head -n1 > instances/example3/instance_ex.lp

# modify instance
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 asprilo-encodings/modified/modify_instance.lp instances/example3/instance_ex.lp | head -n1 > instances/example3/instance_mod.lp

# plan on modified instance
clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=15 asprilo-encodings/modified/encoding.lp instances/example3/instance_mod.lp | head -n1 > instances/example3/plan.lp

# visualize generated instance + plan
viz -t instances/example3/instance_mod.lp instances/example3/plan.lp
