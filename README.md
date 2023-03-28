## Solving Abstractions of Multi-Agent Pathfinding Problems with Answer Set Programming


## Methods
# Modified Original asprilo encoding
Usage of the python script 'original.py': python original.py example_instance.lp
'original.py' uses 'asprilo-encodings/prep/original.lp' and 'asprilo-encodings/modified_orders/encoding.lp'

# Grouping Method
Usage of the python script 'group.py': python group.py -h for detailed usage
'group.py' uses different encodings in 'asprilo-encodings/prep/' and 'asprilo-encodings/group/path.lp'

# CBS style method using an A* like approach
Usage of the python script 'cbs.py': python cbs.py example_instance.lp
'cbs.py' uses different encodings in 'asprilo-encodings/prep/single.lp' and both 'asprilo-encodings/single/path.lp' and 'asprilo-encodings/single/collision.lp'