robot(R)                     	:- init(object(robot,R),_).
shelf(S)                     	:- init(object(shelf,S),_).
isRobot(robot(R)) 				:- robot(R).
isShelf(shelf(S)) 				:- shelf(S).
position((X,Y))   				:- init(object(node,_),value(at,(X,Y))).
position(R,(X,Y),0) 			:- init(object(robot,R),value(at,(X,Y))).
position(shelf(S),(X,Y),0) 		:- init(object(shelf,S),value(at,(X,Y))).