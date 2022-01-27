%clingo $@ --outf=0 -V0 --out-atomf=%s. --quiet=1,2,2 prep.lp cnc_instance.lp | head -n1 > instance.lp
% import instance
init(object(shelf,S),value(at,(X,Y))) :- new_init(object(shelf,S),value(at,(X,Y))).
init(object(robot,R),value(at,(X,Y))) :- new_init(object(robot,R),value(at,(X,Y))).
init(object(node,N),value(at,(X,Y))) :- new_init(object(node,N),value(at,(X,Y))).
rbt(R) :- new_init(object(robot,R),value(at,(X,Y))).

% calculate manhattan distance
md(R,D) :- init(object(robot,R),value(at,(X,Y))), init(object(shelf,S),value(at,(X',Y'))), R==S, D=|X-X'|+|Y-Y'|.


#show.
#show init/2.
#show rbt/1.
#show md/2.
%#show imp_position/2.
