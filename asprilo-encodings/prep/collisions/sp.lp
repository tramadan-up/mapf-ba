% import instance
init(object(shelf,S),value(at,(X,Y))) :- new_init(object(shelf,S),value(at,(X,Y))).
init(object(robot,R),value(at,(X,Y))) :- new_init(object(robot,R),value(at,(X,Y))).
init(object(node,N),value(at,(X,Y))) :- new_init(object(node,N),value(at,(X,Y))).
robot(R) :- new_init(object(robot,R),value(at,(X,Y))).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), imp_position(_,(X,Y),_), imp_position(_,(X',Y'),_), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).
% detect coliisions
collision(R1,R2,(X,Y),T) :- imp_position(R1,(X,Y),T), imp_position(R2,(X,Y),T), R1!=R2.

collision(R1,R2,(X,Y),T) :- imp_position(R1,(X,Y),T), imp_position(R2,(X',Y'),T), imp_position(R1,(X',Y'),T+1), imp_position(R2,(X,Y),T+1), R1!=R2.

% group up robots
robot_cf(R) :- robot(R), not collision(R,_,_,_), not collision(_,R,_,_).
robot_c(R) :- robot(R), not robot_cf(R).

% positions of robots not involved in collisions
position(R,(X,Y),T) :- imp_position(R,(X,Y),T), robot_cf(R).


% group robots sharing collision node
1{share(R,R')} :- collision(R,R',_,_).
share(R,R') :- share(R,RR), share(RR,R').
in_exgroup(R) :- share(R,R'), R!=R'.

{group(R) : in_exgroup(R)}.
%group(R) :- not in_exgroup(R), robot(R).
:- group(R), group(R'), share(R,R'), R!=R'.

grpd(G,R) :- group(G), share(G,R).
:- robot_c(R), not grpd(_,R).
% mark group affiliation
robot(R,G) :- grpd(G,R).
shelf(S,G) :- grpd(G,S).

position_((X,Y),G) :- imp_position(R,(X,Y)), init(object(node,N),value(at,(X,Y))), grpd(G,R).
% add nodes
position_((X+DX,Y+DY),G) :- collision(R,_,(X,Y),_), init_(object(node,N),value(at,(X+DX,Y+DY))), direction((DX,DY)), grpd(G,R).


% calculate manhattan distance
md(R,D) :- init(object(robot,R),value(at,(X,Y))), init(object(shelf,S),value(at,(X',Y'))), R==S, D=|X-X'|+|Y-Y'|.


#show.
#show occurs(object(robot,R),action(move,(DX,DY)),T) : position(R,(X',Y'),T+1), position(R,(X,Y),T), nextto((X,Y),(DX,DY),(X',Y')).
#show position/3.
%#show collision/4.
%#show imp_position/3.
#show init/2.
#show robot/2.
#show shelf/2.
#show md/2.
#show group/1.
#show position_/2.
