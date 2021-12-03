processed(A,R) :- ordered(O,A), shelved(shelf(S),A), isRobot(robot(R)), comb_position(shelf(S),C,0),
                  comb_position(R,C,T), horizon(T), R=S.
processed(A)   :- processed(A,R).
:- ordered(O,A), not processed(A).







