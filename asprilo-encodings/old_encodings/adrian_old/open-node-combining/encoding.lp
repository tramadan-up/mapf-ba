% MODIFIED
#const size_x = 16.
#const size_y = 16.

% Transforming Input ----------------------------
%#include "/home/salewsky/MAPF-Project/encoding/input.lp".
%#include "./input.lp".

% Calculating Moves -----------------------------
%#include "/home/salewsky/MAPF-Project/encoding/open-node-combining/action.lp".
%#include "./action.lp".

% Goal Condition --------------------------------
%#include "/home/salewsky/MAPF-Project/encoding/open-node-combining/goal.lp".
%#include "./goal.lp".

% Transforming Output ---------------------------
%#include "/home/salewsky/MAPF-Project/encoding/open-node-combining/output.lp".
%#include "./output.lp".


% INPUT
robot(R)                     	:- init(object(robot,R),_).
shelf(S)                     	:- init(object(shelf,S),_).
isRobot(robot(R)) 				:- robot(R).
isShelf(shelf(S)) 				:- shelf(S).
position((X,Y))   				:- init(object(node,_),value(at,(X,Y))).
position(R,(X,Y),0) 			:- init(object(robot,R),value(at,(X,Y))).
position(shelf(S),(X,Y),0) 		:- init(object(shelf,S),value(at,(X,Y))).


% ACTION
% Combining Nodes ---------------------------------------------------------------------------------	 
comb_position((X,Y),(X',Y')) 	:- position((X,Y)), X' = (X+(size_x-1))/size_x, Y' = (Y+(size_y-1))/size_y.
comb_position(C)	 			:- comb_position(_,C).
comb_position(R,C',0) 			:- position(R,C,0), comb_position(C,C').
comb_position(shelf(S),C',0) 	:- position(shelf(S),C,0), comb_position(C,C').


% Declaring Time Array ----------------------------------------------------------------------------
time(1..horizon).

% Declaring Directions ----------------------------------------------------------------------------
dir((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.

nextto((X,Y),(DX,DY),(X',Y')) :- dir((DX,DY)), comb_position((X,Y)), comb_position((X',Y')),
                                 (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).
								 


% Calculating Moves and Positions -----------------------------------------------------------------
0 {move(R,D,T) : dir(D)} 1 :- isRobot(robot(R)), time(T).

comb_position(R,C,T) :- move(R,D,T), comb_position(R,C',T-1), nextto(C',D,C).
					 :- move(R,D,T), comb_position(R,C ,T-1), not nextto(C ,D,_).
comb_position(R,C,T) :- comb_position(R,C,T-1), not move(R,_,T), isRobot(robot(R)), time(T).


% Finding important positions ---------------------------------------------------------------------
imp_position(R,C) :- isRobot(robot(R)), comb_position(R,C',_), comb_position(C,C').


% Minimizing Steps ----------------------------------------------------------------------
:- move(R,_,T1), not move(R,_,T2), time(T2), isRobot(robot(R)), T2<T1.
#minimize {1,(R,T): move(R,_,T)}.


% GOAL
% Robots need to be on the shelf with their ID at last time step

goal(R,C) :- isRobot(robot(R)), comb_position(shelf(S),C,0), R=S.
:- isRobot(robot(R)), comb_position(R,C,horizon), goal(R,C'), C!=C'.


% OUTPUT
new_init(object(node,N),value(at,(X,Y)))  			:- imp_position(_,(X,Y)), init(object(node,N),value(at,(X,Y))).
new_init(object(robot,R),value(at,(X,Y))) 			:- init(object(robot,R),value(at,(X,Y))).
new_init(object(shelf,S),value(at,(X,Y)))			:- init(object(shelf,S),value(at,(X,Y))).

#show new_init/2.
#show imp_position/2.
