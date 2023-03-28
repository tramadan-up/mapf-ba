#!/bin/bash
#CONDA_PATH='/opt/anaconda3/etc/profile.d/conda.sh'
#env='asp_clingo'

#python hor_inc.py asprilo-encodings/adrian/shortest-path/encoding.lp instances/demo/example.lp > instances/demo/example_sp.lp

#python cbs.py instances/benchmarks/8_8/ex3_cnc.lp > results/mcbcnc/result_8_8_3_mcbcnc.txt
#python cbs.py instances/benchmarks/8_8/ex4_cnc.lp > results/mcbcnc/result_8_8_4_mcbcnc.txt

#python cbs.py instances/benchmarks/16_16/ex1_cnc.lp > results/mcbcnc/result_16_16_1_mcbcnc.txt

#python cbs.py instances/benchmarks/32_16/ex1_cnc.lp > results/mcbcnc/result_32_16_1_mcbcnc.txt
#python cbs.py instances/benchmarks/32_16/ex2_cnc.lp > results/mcbcnc/result_32_16_2_mcbcnc.txt
#python cbs.py instances/benchmarks/32_16/ex3_cnc.lp > results/cbcnc/result_32_16_3_cbcnc.txt

#python cbs.py instances/benchmarks/64_16/ex1_cnc.lp > results/mcbcnc/result_64_16_1_mcbcnc.txt
python group.py -nc instances/benchmarks/64_16/ex4_cnc.lp 





#source $CONDA_PATH
#conda activate $env
#viz -l /home/t-rex/mapf-ba/solution/group_sp/prep.lp -p /home/t-rex/mapf-ba/solution/group_sp/plan.lp
#conda deactivate
