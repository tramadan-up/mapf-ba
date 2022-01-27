%
crossroad(X,Y) :- init(object(node,N),value(at,(X,Y)),R), init(object(node,N),value(at,(X,Y)),R'), R!=R', R!=0, R'!=0.

init(object(node,N),value(at,(X+1,Y))) 		:- crossroad(X,Y), init(object(node,N),value(at,(X+1,Y)),0).
init(object(node,N),value(at,(X-1,Y))) 		:- crossroad(X,Y), init(object(node,N),value(at,(X-1,Y)),0).
init(object(node,N),value(at,(X,Y+1))) 		:- crossroad(X,Y), init(object(node,N),value(at,(X,Y+1)),0).
init(object(node,N),value(at,(X+1,Y+1))) 	:- crossroad(X,Y), init(object(node,N),value(at,(X+1,Y+1)),0).
init(object(node,N),value(at,(X-1,Y+1))) 	:- crossroad(X,Y), init(object(node,N),value(at,(X-1,Y+1)),0).
init(object(node,N),value(at,(X,Y-1))) 		:- crossroad(X,Y), init(object(node,N),value(at,(X,Y-1)),0).
init(object(node,N),value(at,(X+1,Y-1))) 	:- crossroad(X,Y), init(object(node,N),value(at,(X+1,Y-1)),0).
init(object(node,N),value(at,(X-1,Y-1))) 	:- crossroad(X,Y), init(object(node,N),value(at,(X-1,Y-1)),0).
