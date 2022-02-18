new_init(object(node,N),value(at,(X,Y)),K)  		:- imp_position(_,(X,Y),K), init(object(node,N),value(at,(X,Y))).
new_init(object(robot,R),value(at,(X,Y))) 			:- init(object(robot,R),value(at,(X,Y))).
new_init(object(shelf,S),value(at,(X,Y))) 			:- init(object(shelf,S),value(at,(X,Y))).

%#show new_init/3.
%#show new_init/2.
#show imp_position/3.

