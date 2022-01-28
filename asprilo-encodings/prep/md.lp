%clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 md.lp cnc_instance.lp | head -n1 > instance.lp
% import instance
init(object(shelf,S),value(at,(X,Y))) :- new_init(object(shelf,S),value(at,(X,Y))).
init(object(robot,R),value(at,(X,Y))) :- new_init(object(robot,R),value(at,(X,Y))).
init(object(node,N),value(at,(X,Y))) :- new_init(object(node,N),value(at,(X,Y))).
robot(R) :- new_init(object(robot,R),value(at,(X,Y))).
% calculate manhattan distance
md(R,D) :- init(object(robot,R),value(at,(X,Y))), init(object(shelf,S),value(at,(X',Y'))), R==S, D=|X-X'|+|Y-Y'|.
div(R,D/10) :- md(R,D).
% group robots with regards to their manhattan distance
1{share(R,R')} :- div(R,D), div(R',D).
share(R,R') :- share(R,RR), share(RR,R').
in_exgroup(R) :- share(R,R'), R!=R'.

{group(R) : in_exgroup(R)}.
group(R) :- not in_exgroup(R), robot(R).
:- group(R), group(R'), share(R,R'), R!=R'.

grpd(G,R) :- group(G), share(G,R).
:- robot(R), not grpd(_,R).
% mark group affiliation
robot(R,G) :- grpd(G,R).
shelf(S,G) :- grpd(G,S).
position_((X,Y),G) :- imp_position(R,(X,Y)), init(object(node,N),value(at,(X,Y))), grpd(G,R).

group(R,D) :- group(R), div(R,D).

#show.
#show init/2.
#show robot/2.
#show shelf/2.
#show md/2.
#show group/2.
#show position_/2.

