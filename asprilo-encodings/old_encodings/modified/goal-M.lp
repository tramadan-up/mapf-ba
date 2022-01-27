


processed(A,robot(R)) :- 	ordered(order(O),A), shelved(S,A), isRobot(robot(R)), 								position(S,C,0), position(robot(R),C,horizon), R==O.
processed(A)   :- processed(A,R).

:- ordered(O,A), not processed(A).
