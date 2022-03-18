% import instance
init(object(shelf,S),value(at,(X,Y))) :- new_init(object(shelf,S),value(at,(X,Y))).
init(object(robot,R),value(at,(X,Y))) :- new_init(object(robot,R),value(at,(X,Y))).
init(object(node,N),value(at,(X,Y))) :- new_init(object(node,N),value(at,(X,Y))).
robot(R) :- new_init(object(robot,R),value(at,(X,Y))).

collision(R1,R2,(X,Y)) :- imp_position(R1,(X,Y)), imp_position(R2,(X,Y)), R1!=R2, R1<R2.

collision_md(R1,R2,(X,Y),MD1,MD2) :- collision(R1,R2,(X,Y)), init(object(robot,R1),value(at,(X1,Y1))), init(object(robot,R2),value(at,(X2,Y2))), MD1=|X-X1|+|Y-Y1|, MD2=|X-X2|+|Y-Y2|.

true_collision(R1,R2,(X,Y)) :- collision_md(R1,R2,(X,Y),MD1,MD2), MD1 == MD2.

robot_cf(R) :- new_init(object(robot,R),value(at,(X,Y))), not true_collision(R,_,(_,_)), not true_collision(_,R,(_,_)).
cnt(C) :- C = #count {R:robot_cf(R)}.
%cnt_c(C) :- C = #count {R:robot(R), not robot_cf(R)}.


md(R,D) :- init(object(robot,R),value(at,(X,Y))), init(object(shelf,S),value(at,(X',Y'))), R==S, D=|X-X'|+|Y-Y'|.

#show.
#show true_collision/3.
#show robot_cf/1.
#show cnt/1.
%#show cnt_c/1.
