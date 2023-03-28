%#const horizon=1.
time(1..horizon).

direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.
nextto((X,Y),(DX,DY),(X',Y')) :- direction((DX,DY)), position((X,Y)), position((X',Y')),
                                 (X,Y)=(X'-DX,Y'-DY), (X',Y')=(X+DX,Y+DY).

{ move(R,D,T) : direction(D) } 1 :- isRobot(R), time(T).

% - move/3 ----------------------------------------------------------------------
position(R,C,T) :- move(R,D,T), position(R,C',T-1),     nextto(C',D,C).
                :- move(R,D,T), position(R,C ,T-1), not nextto(C ,D,_).

% - inertia ---------------------------------------------------------------------
position(R,C,T) :- position(R,C,T-1), not move(R,_,T), isRobot(R), time(T).

% - edge collision --------------------------------------------------------------
moveto(C',C,T) :- nextto(C',D,C), position(R,C',T-1), move(R,D,T).
 :- moveto(C',C,T), moveto(C,C',T), C < C'.

% - vertex collision ------------------------------------------------------------
 :- { position(R,C,T) : isRobot(R) }  > 1, position(C), time(T).

% - auxiliaries -----------------------------------------------------------------
 :- { position(R,C,T) } != 1, isRobot(R), time(T).    % REDUNDANT but PERFORMANT?
 
% --------------------------------------------------------------------------------
% REPRESENTATION

robot(R)                     :- init(object(robot,R),          _).
shelf(S)                     :- init(object(shelf,S),          _).


isRobot(robot(R)) :- robot(R).
isShelf(shelf(S)) :- shelf(S).

position(           (X,Y))   :- init(object(node,_),           value(at,(X,Y))).
position(  robot(R),(X,Y),0) :- init(object(robot,R),          value(at,(X,Y))).
position(  shelf(S),(X,Y)) :- init(object(shelf,S),          value(at,(X,Y))).


 
processed(R,robot(R)) :- position(shelf(S),(X,Y)), isRobot(robot(R)), position(robot(R),(X,Y),horizon), R==S.


processed(R)   :- processed(R,robot(R)).

:- robot(R), not processed(R).


#show.
#show init/2.
#show occurs(object(robot,R), action(move,D),     T) :    move(robot(R),D,T).

init(object(robot,1),value(max_energy,0)). init(object(robot,1),value(energy,0)). init(object(robot,2),value(max_energy,0)). init(object(robot,2),value(energy,0)). init(object(robot,3),value(max_energy,0)). init(object(robot,3),value(energy,0)). init(object(robot,4),value(max_energy,0)). init(object(robot,4),value(energy,0)). init(object(robot,5),value(max_energy,0)). init(object(robot,5),value(energy,0)). init(object(robot,6),value(max_energy,0)). init(object(robot,6),value(energy,0)). init(object(robot,7),value(max_energy,0)). init(object(robot,7),value(energy,0)). init(object(robot,8),value(max_energy,0)). init(object(robot,8),value(energy,0)). init(object(order,1),value(pickingStation,1)). init(object(order,2),value(pickingStation,1)). init(object(order,3),value(pickingStation,1)). init(object(order,4),value(pickingStation,1)). init(object(order,5),value(pickingStation,1)). init(object(order,6),value(pickingStation,1)). init(object(order,7),value(pickingStation,1)). init(object(order,8),value(pickingStation,1)). init(object(node,1),value(at,(1,1))). init(object(node,2),value(at,(2,1))). init(object(node,3),value(at,(3,1))). init(object(node,4),value(at,(4,1))). init(object(node,5),value(at,(5,1))). init(object(node,6),value(at,(6,1))). init(object(node,7),value(at,(7,1))). init(object(node,8),value(at,(8,1))). init(object(node,9),value(at,(1,2))). init(object(node,10),value(at,(2,2))). init(object(node,11),value(at,(3,2))). init(object(node,12),value(at,(4,2))). init(object(node,13),value(at,(5,2))). init(object(node,14),value(at,(6,2))). init(object(node,15),value(at,(7,2))). init(object(node,16),value(at,(8,2))). init(object(node,17),value(at,(1,3))). init(object(node,18),value(at,(2,3))). init(object(node,19),value(at,(3,3))). init(object(node,20),value(at,(4,3))). init(object(node,21),value(at,(5,3))). init(object(node,22),value(at,(6,3))). init(object(node,23),value(at,(7,3))). init(object(node,24),value(at,(8,3))). init(object(node,25),value(at,(1,4))). init(object(node,26),value(at,(2,4))). init(object(node,27),value(at,(3,4))). init(object(node,28),value(at,(4,4))). init(object(node,29),value(at,(5,4))). init(object(node,30),value(at,(6,4))). init(object(node,31),value(at,(7,4))). init(object(node,32),value(at,(8,4))). init(object(node,33),value(at,(1,5))). init(object(node,34),value(at,(2,5))). init(object(node,35),value(at,(3,5))). init(object(node,36),value(at,(4,5))). init(object(node,37),value(at,(5,5))). init(object(node,38),value(at,(6,5))). init(object(node,39),value(at,(7,5))). init(object(node,40),value(at,(8,5))). init(object(node,41),value(at,(1,6))). init(object(node,42),value(at,(2,6))). init(object(node,43),value(at,(3,6))). init(object(node,44),value(at,(4,6))). init(object(node,45),value(at,(5,6))). init(object(node,46),value(at,(6,6))). init(object(node,47),value(at,(7,6))). init(object(node,48),value(at,(8,6))). init(object(node,49),value(at,(1,7))). init(object(node,50),value(at,(2,7))). init(object(node,51),value(at,(3,7))). init(object(node,52),value(at,(4,7))). init(object(node,53),value(at,(5,7))). init(object(node,54),value(at,(6,7))). init(object(node,55),value(at,(7,7))). init(object(node,56),value(at,(8,7))). init(object(node,57),value(at,(1,8))). init(object(node,58),value(at,(2,8))). init(object(node,59),value(at,(3,8))). init(object(node,60),value(at,(4,8))). init(object(node,61),value(at,(5,8))). init(object(node,62),value(at,(6,8))). init(object(node,63),value(at,(7,8))). init(object(node,64),value(at,(8,8))). init(object(robot,1),value(at,(1,8))). init(object(robot,2),value(at,(2,8))). init(object(robot,3),value(at,(3,8))). init(object(robot,4),value(at,(4,8))). init(object(robot,5),value(at,(5,8))). init(object(robot,6),value(at,(6,8))). init(object(robot,7),value(at,(7,8))). init(object(robot,8),value(at,(8,8))). init(object(shelf,1),value(at,(1,1))). init(object(product,1),value(on,(1,1))). init(object(shelf,2),value(at,(2,1))). init(object(product,2),value(on,(2,1))). init(object(shelf,3),value(at,(3,1))). init(object(product,3),value(on,(3,1))). init(object(shelf,4),value(at,(4,1))). init(object(product,4),value(on,(4,1))). init(object(shelf,5),value(at,(5,1))). init(object(product,5),value(on,(5,1))). init(object(shelf,6),value(at,(6,1))). init(object(product,6),value(on,(6,1))). init(object(shelf,7),value(at,(7,1))). init(object(product,7),value(on,(7,1))). init(object(shelf,8),value(at,(8,1))). init(object(product,8),value(on,(8,1))). init(object(order,1),value(line,(1,1))). init(object(order,2),value(line,(2,1))). init(object(order,3),value(line,(3,1))). init(object(order,4),value(line,(4,1))). init(object(order,5),value(line,(5,1))). init(object(order,6),value(line,(6,1))). init(object(order,7),value(line,(7,1))). init(object(order,8),value(line,(8,1))). md(1,7). md(2,7). md(3,7). md(4,7). md(5,7). md(6,7). md(7,7). md(8,7). 