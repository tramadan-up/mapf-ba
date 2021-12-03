new_init(object(shelf,1),value(at,(5,3))). new_init(object(shelf,2),value(at,(3,5))). new_init(object(robot,1),value(at,(1,3))). new_init(object(robot,2),value(at,(3,1))). new_init(object(node,11),value(at,(1,3))). new_init(object(node,12),value(at,(2,3))). new_init(object(node,16),value(at,(1,4))). new_init(object(node,17),value(at,(2,4))). new_init(object(node,3),value(at,(3,1))). new_init(object(node,4),value(at,(4,1))). new_init(object(node,8),value(at,(3,2))). new_init(object(node,9),value(at,(4,2))). new_init(object(node,15),value(at,(5,3))). new_init(object(node,20),value(at,(5,4))). new_init(object(node,23),value(at,(3,5))). new_init(object(node,24),value(at,(4,5))). new_init(object(node,13),value(at,(3,3))). new_init(object(node,14),value(at,(4,3))). new_init(object(node,18),value(at,(3,4))). new_init(object(node,19),value(at,(4,4))).
%#const horizon=1.
%#const rid=1.

% import new instance
robot(R) :- new_init(object(robot,R),_), R==rid.
shelf(Sh) :- new_init(object(shelf,Sh),_), Sh==rid.
position((X,Y)) :- new_init(object(node,_),value(at,(X,Y))).



time(1..horizon).
restricted_position(R,(0,0),0) :- robot(R), R==rid.

% important positions
position(R,(X,Y),0) :- robot(R), new_init(object(robot,R),value(at,(X,Y))), position((X,Y)), R==rid.
position((X,Y),Sh) :- shelf(Sh), new_init(object(shelf,Sh),value(at,(X,Y))), position((X,Y)), Sh==rid.
goal_position(R,(X,Y),Sh) :- robot(R), position((X,Y),Sh), shelf(Sh), R==S.
goal(R,C) :- goal_position(R,C,_).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).


{ move(R,D,T) : direction(D)} 1 :- robot(R), time(T).

position(R,C,T) :- move(R,D,T), position(R,C',T-1),     nextto(C',D,C), not restricted_position(R,C,T).
                :- move(R,D,T), position(R,C ,T-1), not nextto(C ,D,_), not restricted_position(R,C,T).

position(R,C,T) :- position(R,C,T-1), not move(R,_,T), robot(R), time(T), not restricted_position(R,C,T).

:- { position(R,C,T) } != 1, robot(R), time(T).

:- position(R,C,horizon), goal(R,C'), C!=C'.
#show.
#show position/3.

