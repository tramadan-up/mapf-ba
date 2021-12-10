%#const horizon=1.
%#const rid=1.

% import abtracted instance
robot(R) :- new_init(object(robot,R),_), R==rid.
shelf(Sh) :- new_init(object(shelf,Sh),_), Sh==rid.
checkpoint(R,(X,Y)) :- new_checkpoint(R,(X,Y)), R==rid.
position((X,Y)) :- new_init(object(node,_),value(at,(X,Y))).

% set time with given horizon
time(1..horizon).

restricted_position(R,(0,0),0) :- robot(R), R==rid.

% start and goal positions, shelf position
position(R,(X,Y),0) :- robot(R), new_init(object(robot,R),value(at,(X,Y))), position((X,Y)), R==rid.
position((X,Y),Sh) :- shelf(Sh), new_init(object(shelf,Sh),value(at,(X,Y))), position((X,Y)), Sh==rid.
goal_position(R,(X,Y),Sh) :- robot(R), position((X,Y),Sh), shelf(Sh), R==S.
goal(R,C) :- goal_position(R,C,_).

% checkpoints
%checkpoint(R,(X,Y))

% directions
direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).

% movement and positions
{ move(R,D,T) : direction(D)} 1 :- robot(R), time(T).

position(R,C,T) :- move(R,D,T), position(R,C',T-1),     nextto(C',D,C), not restricted_position(R,C,T).
                :- move(R,D,T), position(R,C ,T-1), not nextto(C ,D,_), not restricted_position(R,C,T).

position(R,C,T) :- position(R,C,T-1), not move(R,_,T), robot(R), time(T), not restricted_position(R,C,T).

:- { position(R,C,T) } != 1, robot(R), time(T).

:- checkpoint(R,C), not position(R,C,_).
:- position(R,C,horizon), goal(R,C'), C!=C'.


#show.
#show checkpoint/2.
#show position/3.
#show occurs(object(robot,R), action(move,D),     T) :    move(R,D,T).

