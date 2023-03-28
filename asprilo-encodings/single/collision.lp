%#const rid = 1.
%time(T) :- position(_,_,T).
collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X,Y),T), R1!=R2.
collision(R1,(X',Y'),T+1) :- position(R1,(X,Y),T), position(R2,(X',Y'),T), position(R1,(X',Y'),T+1), position(R2,(X,Y),T+1), R1!=R2, not collision(R2,(X,Y),T+1).
%collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T'), position(R2,(X,Y),T), not position(R1,_,T'+P), S=T-T', P=1..S, T'<T, R1!=R2.
collision(C,T) :- collision(_,_,C,T).
collision(C,T) :- collision(_,C,T).
%h(C,R,T,H) = heuristic(manhattan distance) of the collision node(X,Y) time step T to the goal(X',Y') 
h((X,Y),R1,T,H) :- collision(R1,R2,(X,Y),T), goal(R1,(X',Y')), H=|X-X'|+|Y-Y'|.
h((X,Y),R1,T,H) :- collision(R1,(X,Y),T), goal(R1,(X',Y')), H=|X-X'|+|Y-Y'|.

%h((X,Y),R1,T) :- collision(R1,_,(X,Y),T).
%choose exactly one collison with the lowest h-value
1 {s(C,R,T,H) : h(C,R,T,H)} 1 :- collision(C,T).
%1 {s(C,R,T) : h(C,R,T)} 1 :- collision(C,T).
:- s(C,R,T,H), h(C,_,T,H'), H'<H, H!=H'.
:- h(C,_,T,_), not s(C,_,T,_).
constraint(C,R,T) :- s(C,R,T,_).
constraint(C,R,T+1) :- collision(R,C,T).
%:- constraint(_,_,T), T==0.
%constraint(C,R,T) :- s(C,R,T).
robot_c(R) :- constraint(_,R,_).
#show.
#show collision/4.
#show h/4.
#show constraint/3.
#show robot_c/1.



