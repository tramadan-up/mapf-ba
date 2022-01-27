%#const rid = 1.

collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X,Y),T), R1!=R2.
collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X',Y'),T), position(R1,(X',Y'),T+1), position(R2,(X,Y),T+1), R1!=R2.
%collision(R1,R2,(X,Y),T) :- position(R1,(X,Y),T), position(R2,(X+DX,Y+DY),T), position(R1,(X+DX,Y+DY),T+1), position(R2,(X,Y),T+1), R1!=R2, DX=-1..1, DY=-1..1, |DX|+|DY|=1.

#show.
#show collisions(R1,R2,(X,Y),T) : collision(R1,R2,(X,Y),T), R1!=rid.
