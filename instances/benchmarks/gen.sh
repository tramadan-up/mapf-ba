#!/bin/bash
CONDA_PATH='/opt/anaconda3/etc/profile.d/conda.sh'
env='asp_clingo'

#https://asprilo.github.io/generator/
#x-dimension
x=25
#y-dimension
y=10
#shelf x-dimension
X=6
#shelf y-dimension
Y=2
#shelves
s=25
#picking station
p=1
#robots
r=25
#products
P=25
#product units
u=25
#orders
o=25

source $CONDA_PATH
conda activate $env
gen -x $x -y $y -X $X -Y $Y -s $s -p $p -r $r -H -P $P -u $u -o $o --prsmax 1 --oap -t 16 -I
conda deactivate

