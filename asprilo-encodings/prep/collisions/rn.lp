% import instance
init(object(shelf,S),value(at,(X,Y))) :- new_init(object(shelf,S),value(at,(X,Y))).
init(object(robot,R),value(at,(X,Y))) :- new_init(object(robot,R),value(at,(X,Y))).
init(object(node,N),value(at,(X,Y))) :- new_init(object(node,N),value(at,(X,Y))).
robot(R) :- new_init(object(robot,R),value(at,(X,Y))).
% imp_position(R,(X,Y),0)

%init_position((X,Y)) :- init(object(node,N),value(at,(X,Y))).
init_position(R,(X,Y)) :- imp_position(R,(X,Y),0).
position((X,Y),S) :- init(object(shelf,S),value(at,(X,Y))).
goal_position(R,(X,Y),S) :- robot(R), position((X,Y),S), R==S.
goal(R,C) :- goal_position(R,C,_).

% calculate manhattan distance
md(R,D) :- init(object(robot,R),value(at,(X,Y))), init(object(shelf,S),value(at,(X',Y'))), R==S, D=|X-X'|+|Y-Y'|.
time(0..D,R) :- md(R,D).
time(0..D) :- md(_,D).

% generate a plan for each robot
% directions
direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto(R,(X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), init_position(R,(X,Y)), init_position(R,(X',Y')), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).
nextto((X,Y),(DX,DY),(X',Y')) :- nextto(_,(X,Y),(DX,DY),(X',Y')).
% movement and positions
{ move(R,D,T) : direction(D)} 1 :- robot(R), time(T,R).

position_pre(R,(X,Y),0) :- init(object(robot,R),value(at,(X,Y))).
position_pre(R,C,T) :- move(R,D,T), position_pre(R,C',T-1),     nextto(R,C',D,C).
                :- move(R,D,T), position_pre(R,C ,T-1), not nextto(R,C ,D,_).

position_pre(R,C,T) :- position_pre(R,C,T-1), not move(R,_,T), robot(R), time(T,R).
moveto(C',C,T) :- nextto(R,C',D,C), position_pre(R,C',T-1), move(R,D,T).
:- moveto(C',C,T), moveto(C,C',T), C < C'.

%:- { position_pre(R,C,T) : robot(R) }  > 1, imp_position_pre(R,(X,Y)), time(T).
:- { position_pre(R,C,T) } != 1, robot(R), time(T,R).
:- position_pre(R,C,D), goal(R,C'), md(R,D), C!=C'.


% look for collisions
collision(R1,R2,(X,Y),T) :- position_pre(R1,(X,Y),T), position_pre(R2,(X,Y),T), R1!=R2.

collision(R1,R2,(X,Y),T) :- position_pre(R1,(X,Y),T), position_pre(R2,(X',Y'),T), position_pre(R1,(X',Y'),T+1), position_pre(R2,(X,Y),T+1), R1!=R2.

% group up robots
robot_cf(R) :- robot(R), not collision(R,_,_,_), not collision(_,R,_,_).
robot_c(R) :- robot(R), not robot_cf(R).

% positions of robots not involved in collisions
position(R,(X,Y),T) :- position_pre(R,(X,Y),T), robot_cf(R).

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

position_((X,Y),G) :- imp_position(R,(X,Y),0), init(object(node,N),value(at,(X,Y))), grpd(G,R).
% add nodes
position_((X+DX,Y+DY),G) :- collision(R,_,(X,Y),_), init_(object(node,N),value(at,(X+DX,Y+DY))), direction((DX,DY)), grpd(G,R).

#show.
#show occurs(object(robot,R),action(move,(DX,DY)),T) : position(R,(X',Y'),T+1), position(R,(X,Y),T), nextto((X,Y),(DX,DY),(X',Y')).
#show position/3.
%#show occurs(object(robot,R), action(move,D),     T) :    move(R,D,T).
#show init/2.
#show robot/2.
#show shelf/2.
#show md/2.
#show group/1.
#show position_/2.
