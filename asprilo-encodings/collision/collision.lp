%#const rid = 1.
collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X,Y),T), R1!=R2.

%collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X',Y),T), position(R1,(X',Y),T+1), position(R2,(X,Y),T+1), R1!=R2.
%collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X,Y'),T), position(R1,(X,Y'),T+1), position(R2,(X,Y),T+1), R1!=R2.


collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X+1,Y),T), position(R1,(X+1,Y),T+1), position(R2,(X,Y),T+1), R1!=R2.

collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X-1,Y),T), position(R1,(X-1,Y),T+1), position(R2,(X,Y),T+1), R1!=R2.

collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X,Y+1),T), position(R1,(X,Y+1),T+1), position(R2,(X,Y),T+1), R1!=R2.

collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X,Y-1),T), position(R1,(X,Y-1),T+1), position(R2,(X,Y),T+1), R1!=R2.

#show.
#show restricted_position(R1,(X,Y),T) : collision(R1,R2,(X,Y),T), R1==rid.
