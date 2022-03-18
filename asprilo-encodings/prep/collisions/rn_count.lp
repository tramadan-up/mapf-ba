% import instance
init(object(shelf,S),value(at,(X,Y))) :- new_init(object(shelf,S),value(at,(X,Y))).
init(object(robot,R),value(at,(X,Y))) :- new_init(object(robot,R),value(at,(X,Y))).
init(object(node,N),value(at,(X,Y))) :- new_init(object(node,N),value(at,(X,Y))).
robot(R) :- new_init(object(robot,R),value(at,(X,Y))).

%count positions
cnt(C,R) :- C = #count {X+Y*Y:imp_position(R,(X,Y),0)}, robot(R).

% b plan for each robot

% both: look for collisions

% a group up robots, add nodes
% b extract info of robots to be replaned, add nodes


#show.
#show cnt/2.
