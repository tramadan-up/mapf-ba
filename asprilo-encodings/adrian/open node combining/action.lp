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