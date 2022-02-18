% calculate manhattan distance
md(R,D) :- init(object(robot,R),value(at,(X,Y))), init(object(shelf,S),value(at,(X',Y'))), R==S, D=|X-X'|+|Y-Y'|.

