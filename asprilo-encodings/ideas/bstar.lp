%clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 -c horizon=6 -c grp=1 ./ideas/bstar.lp ./solution/group_sp/prep.lp > ./ideas/example.lp
%init(object(shelf,S),value(at,(X,Y))).
%init(object(robot,R),value(at,(X,Y))).
%init(object(node,N),value(at,(X,Y))).
%group(R).
%robot(R,G).
%shelf(S,G).
%position_((X,Y),G).
%md(R,D).

%#const horizon=1.
%#const grp=1.
% set time with given horizon
time(1..horizon).
% import
robot(R) :- robot(R,G), G==grp.
robots(R) :- init(object(robot,R),_).
position(R,(X,Y),0) :- robot(R,G), init(object(robot,R),value(at,(X,Y))), G==grp.
position((X,Y),S) :- shelf(S,G), init(object(shelf,S),value(at,(X,Y))), G==grp.
goal_position(R,(X,Y),S) :- robot(R), position((X,Y),S), shelf(S,G), R==S, G==grp.
goal(R,C) :- goal_position(R,C,_).

% directions
direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position_((X,Y),G), position_((X',Y'),G), (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY), G==grp.

%g(C,C',R,G) = cost G(+1) to get to node C from the start node
g(C,C', R, G) :- position(R,_,0), position(R,C',G'), nextto(C',_,C), C==C', G=G'. 
g(C,C', R, G) :- position(R,_,0), position(R,C',G'), nextto(C',_,C), C!=C', G=G'+1.

%h(C,R,T,H) = heuristic(manhattan distance) of the node(X,Y) next to the visited node(Xv,Yv) at time step T to the goal(X',Y') 
h((X,Y),R,T,H) :- position(R,(Xv,Yv),T), nextto((Xv,Yv),(DX,DY),(X,Y)), goal(R,(X',Y')), H=|X-X'|+|Y-Y'|.

%f(C,R,T,F) = f-value of the node C next to the visited node at time step T
f(C,R,T,F) :- position(R,C',T), g(C,C',R,G), h(C,R,T,H), F=G+H.

%choose next move
{move(R,D,F,T): direction(D)} 1 :- robot(R), time(T), position(R,C',T-1), f(C,R,T-1,F), nextto(C',D,C).

position(R,C,T) :- move(R,D,_,T), position(R,C',T-1),     nextto(C',D,C).
                :- move(R,D,_,T), position(R,C ,T-1), not nextto(C ,D,_).

position(R,C,T) :- position(R,C,T-1), not move(R,_,_,T), robot(R), time(T).
moveto(C',C,T) :- nextto(C',D,C), position(R,C',T-1), move(R,D,_,T).
:- moveto(C',C,T), moveto(C,C',T), C < C'.
%:- { position(R,C,T) : robot(R) }  > 1, position_(C,G), time(T), G==grp.
:- { position(R,C,T) : robots(R) }  > 1, init(_,value(at,C)), time(T).
:- { position(R,C,T) } != 1, robot(R), time(T).
:- position(R,C,horizon), goal(R,C'), C!=C'.

%#minimize {F,R,T : move(R,_,T,F)}.


#show.
#show position/3.
%%#show occurs(object(robot,R), action(move,D),     T) :    move(R,D,T).
#show occurs(object(robot,R),action(move,(DX,DY)),T) : position(R,(X',Y'),T+1), position(R,(X,Y),T), nextto((X,Y),(DX,DY),(X',Y')).
%#show occurs/3.
