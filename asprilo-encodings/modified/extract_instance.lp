%
time(0).
position(robot(R),(X,Y),0) :- init(object(robot,R),value(at,(X,Y))).
position(robot(R),(X+DX,Y+DY),T+1) :- occurs(object(robot,R),action(move,(DX,DY)),T+1), position(robot(R),(X,Y),T).



#show.
#show init(object(node,N),value(at,(X,Y))) : position(robot(_),(X,Y),T), init(object(node,N),value(at,(X,Y))), time(T).
#show init(object(node,N),value(at,(X,Y)),R) : position(robot(R),(X,Y),T), init(object(node,N),value(at,(X,Y))), time(T).
#show init(object(node,N),value(at,(X,Y)),0) : init(object(node,N),value(at,(X,Y))).


#show init(object(robot,R), value(at,(X,Y))) : init(object(robot,R), value(at,(X,Y))).
#show init(object(robot,R), value(max_energy,E)) : init(object(robot,R), value(max_energy,E)).
#show init(object(robot,R), value(energy,E)) : init(object(robot,R), value(energy,E)).
#show init(object(shelf,S), value(at,(X,Y))) : init(object(shelf,S), value(at,(X,Y))).
#show init(object(product,P),value(on,(X,Y))) : init(object(product,P),value(on,(X,Y))).
#show init(object(pickingStation,P), value(at,(X,Y))) : init(object(pickingStation,P), value(at,(X,Y))).
#show init(object(order,O),value(pickingStation,P)) : init(object(order,O),value(pickingStation,P)).
#show init(object(order,O),value(line,(X,Y))) : init(object(order,O),value(line,(X,Y))).
