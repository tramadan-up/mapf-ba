new_init(object(node,N),value(at,(X,Y))) :- init(object(node,N),value(at,(X,Y))).
new_init(object(robot,R),value(at,(X,Y))) :- init(object(robot,R),value(at,(X,Y))).
new_init(object(shelf,S),value(at,(X,Y))) :- init(object(shelf,S),value(at,(X,Y))).
new_init(object(order,O),value(line,(X,Y))) :- init(object(order,O),value(line,(X,Y))).
new_init(object(order,O),value(pickingStation,1)) :- init(object(order,O),value(pickingStation,1)).
new_init(object(product,P),value(on,(X,Y))) :- init(object(product,P),value(on,(X,Y))).
imp_position(R,(X,Y)) :- init(object(node,_),value(at,(X,Y))), init(object(robot,R),value(at,(_,_))).
