robot(R)                     :- init(object(robot,R),_).
shelf(S)                     :- init(object(shelf,S),_).
station(P)                   :- init(object(pickingStation,P),_).
product(A)                   :- init(object(product,A),_).
order(O) 					 :- init(object(order,O),_).

isRobot(robot(R)) 		:- robot(R).
isShelf(shelf(S)) 		:- shelf(S).
isStation(station(T)) 	:- station(T).
isProduct(product(A)) 	:- product(A).
isOrder(order(O)) 		:- order(O).


ordered(order(O),product(A)) :- init(object(order,O),value(line,(A,_))).
target(order(O),station(P))  :- init(object(order,O),value(pickingStation,P)).
shelved(shelf(S),product(A)) :- init(object(product,A),value(on,(S,_))).        


position((X,Y))   				:- init(object(node,_),value(at,(X,Y))).
position(station(P),(X,Y))   	:- init(object(pickingStation,P), value(at,(X,Y))).
position(R,(X,Y),0) 			:- init(object(robot,R),value(at,(X,Y))).
position(shelf(S),(X,Y),0) 		:- init(object(shelf,S),value(at,(X,Y))).




 



