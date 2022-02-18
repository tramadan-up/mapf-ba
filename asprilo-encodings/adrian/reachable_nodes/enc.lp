%
robot(R)                     	:- init(object(robot,R),_).
shelf(S)                     	:- init(object(shelf,S),_).
isRobot(robot(R)) 				:- robot(R).
isShelf(shelf(S)) 				:- shelf(S).
position((X,Y))   				:- init(object(node,_),value(at,(X,Y))).
position(R,(X,Y),0) 			:- init(object(robot,R),value(at,(X,Y))).
position(shelf(S),(X,Y),0) 		:- init(object(shelf,S),value(at,(X,Y))).

% Declaring Time Array ------------------------------------------------------------------
time(1..horizon).


% Declaring Directions ------------------------------------------------------------------
dir((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.

nextto((X,Y),(DX,DY),(X',Y')) :- dir((DX,DY)), position((X,Y)), position((X',Y')),
                                 (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).
								 


% Calculating Moves and Positions -------------------------------------------------------
0 {move(R,D,T) : dir(D)} 1 :- isRobot(robot(R)), time(T).

position(R,C,T) :- move(R,D,T), position(R,C',T-1),     nextto(C',D,C).
                :- move(R,D,T), position(R,C ,T-1), not nextto(C ,D,_).
position(R,C,T) :- not move(R,_,T), position(R,C,T-1), isRobot(robot(R)), time(T).


% Minimizing Steps ----------------------------------------------------------------------
:- move(R,_,T1), not move(R,_,T2), time(T2), isRobot(robot(R)), T2<T1.
#minimize {1,(R,T): move(R,_,T)}.


% Calculating Important Positions -------------------------------------------------------
imp_pos(R,C,0) 	:- isRobot(robot(R)), position(R,C,_).
%imp_pos(R,C,N)	:- isRobot(robot(R)), imp_pos(R,C',N-1), nextto(C',_,C), not imp_pos(R,C,N-2),
					
imp_pos(R,C,N) 	:- isRobot(robot(R)), imp_pos(R,C',N-1), init(object(node,N),value(at,_)), nextto(C',_,C).

imp_position(R,C,MIN) 		:- imp_pos(R,C,MIN), MIN == #min{X: imp_pos(R,C,X)}.


% Robots need to be on the shelf with their ID at last time step

goal(R,C) :- isRobot(robot(R)), position(shelf(S),C,0), R=S.
:- isRobot(robot(R)), position(R,C,horizon), goal(R,C'), C!=C'.


new_init(object(node,N),value(at,(X,Y)),K)  		:- imp_position(_,(X,Y),K), init(object(node,N),value(at,(X,Y))).
new_init(object(node,N),value(at,(X,Y)))  		:- imp_position(_,(X,Y),_), init(object(node,N),value(at,(X,Y))).
new_init(object(robot,R),value(at,(X,Y))) 			:- init(object(robot,R),value(at,(X,Y))).
new_init(object(shelf,S),value(at,(X,Y))) 			:- init(object(shelf,S),value(at,(X,Y))).

%#show new_init/3.
#show new_init/2.
#show imp_position/3.
