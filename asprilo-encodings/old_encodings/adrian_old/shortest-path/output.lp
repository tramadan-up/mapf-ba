new_init(object(node,N),value(at,(X,Y)))  			:- imp_position(_,(X,Y)), init(object(node,N),value(at,(X,Y))).
init_(object(node,N),value(at,(X,Y)))				:- init(object(node,N),value(at,(X,Y))). %MODIFIED
new_init(object(robot,R),value(at,(X,Y))) 			:- init(object(robot,R),value(at,(X,Y))).
new_init(object(shelf,S),value(at,(X,Y))) 			:- init(object(shelf,S),value(at,(X,Y))).

#show init_/2.   %MODIFIED
#show new_init/2.
#show imp_position/2.
#show imp_position/3. %MODIFIED
