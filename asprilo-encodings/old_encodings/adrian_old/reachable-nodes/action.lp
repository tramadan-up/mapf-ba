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
makespan(R,N) :- move(R,_,N).
imp_pos(R,C,0) 	:- isRobot(robot(R)), position(R,C,_).
imp_pos(R,C,N) 	:- isRobot(robot(R)), imp_pos(R,C',N-1), makespan(R,N), nextto(C',_,C).
imp_position(R,C,MIN) 		:- imp_pos(R,C,MIN), MIN == #min{X: imp_pos(R,C,X)}.

