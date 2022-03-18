% Robots need to be on the shelf with their ID at last time step

goal(R,C) :- isRobot(robot(R)), position(shelf(S),C,0), R=S.
:- isRobot(robot(R)), position(R,C,horizon), goal(R,C'), C!=C'.





