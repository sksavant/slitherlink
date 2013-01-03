:-use_module(library(clpfd)).

solve(_,_,Dots,Clues,Edges):- maplist(dom, Edges), include(onetwoTest,Edges,Os), constraintA(Os,Edges), constraintC(Clues,Edges),
								constraintE(Dots,Edges), getStates(Edges, Ss), labeling([ffc],Ss), 
								include(dotInLoop(Edges),Dots,Loop), singleLoop(Loop,Edges), writeln(Edges).

singleLoop(Dots, Edges):- include(dotInLoop(Edges),Dots,Loop), loopCount(Loop, Edges, C), C #= 1.

selectDot(I,J,[dot(I,J)|_]).

dotInLoop(Edges, dot(I,J)) :- member(edge(I,J,_,1),Edges). 

loopCount([],_,0).
loopCount(Loop,Edges,C):- selectDot(I,J,Loop), cycle(Loop, Edges, dot(I,J),[],Visited), removeVisited(Visited, Loop, Loop1), 
							C #= C1 + 1, loopCount(Loop1,Edges, C1).

removeVisited([],A,A).
removeVisited([dot(I,J)|Ds], Loop, Loop1):- select(dot(I,J),Loop,Loop2), removeVisited(Ds, Loop2, Loop1). 



copy(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).


cycle(_,_, Curr , Visited, RetList) :- member(Curr, Visited ),copy(Visited, RetList),!. 
cycle(Ds, Edges, Curr , [],X ) :- nextDot(Ds, Edges, dot(0,0), Curr , Next ), cycle(Ds, Edges, Next , [Curr],X).
cycle(Ds, Edges, Curr , [Prev|Visited],X) :- nextDot(Ds, Edges, Prev, Curr , Next ), cycle(Ds, Edges, Next , [Curr|[Prev|Visited]],X).


nextDot(Ds, Edges, dot(I,J), dot(I1,J1), dot(I2,J2)):- I2 #= I1, J2 #= J1 + 1, I2 #\= I #\/ J2 #\= J, member(dot(I2,J2),Ds), member(edge(I1,J1,1,1),Edges), member(edge(I2,J2,3,1),Edges).
nextDot(Ds, Edges, dot(I,J), dot(I1,J1), dot(I2,J2)):- I2 #= I1, J2 #= J1 - 1, I2 #\= I #\/ J2 #\= J, member(dot(I2,J2),Ds), member(edge(I1,J1,3,1),Edges), member(edge(I2,J2,1,1),Edges).
nextDot(Ds, Edges, dot(I,J), dot(I1,J1), dot(I2,J2)):- I2 #= I1 + 1, J2 #= J1, I2 #\= I #\/ J2 #\= J, member(dot(I2,J2),Ds), member(edge(I1,J1,2,1),Edges), member(edge(I2,J2,4,1),Edges).
nextDot(Ds, Edges, dot(I,J), dot(I1,J1), dot(I2,J2)):- I2 #= I1 - 1, J2 #= J1, I2 #\= I #\/ J2 #\= J, member(dot(I2,J2),Ds), member(edge(I1,J1,4,1),Edges), member(edge(I2,J2,2,1),Edges).


output([]).

output([edge(I,J,K)|Es]):- writef('[%w,%w,%w]',[I,J,K]), output(Es).

getStates([],[]).
getStates([edge(_,_,_,A)|Ds],[A|Ss]):-getStates(Ds,Ss).

dom(edge(_,_,_,A)):-A in 0..1.

onetwoTest(edge(_,_,A,_)) :- A #= 1 #\/ A#= 2.
twoTest(edge(_,_,2,_)).

constraintA([],_).


constraintA([edge(I,J,1,_)|Es], Edges):- member(edge(I,J,1,S1),Edges), J1 #= J + 1, member(edge(I,J1,3,S2),Edges), S1 #= S2, constraintA(Es,Edges).
constraintA([edge(I,J,2,_)|Es], Edges):- member(edge(I,J,2,S1),Edges), I1 #= I + 1, member(edge(I1,J,4,S2),Edges), S1 #= S2, constraintA(Es,Edges).

constraintC([],_).
constraintC([clue(I,J,-1)|Cs],Edges):- member(edge(I,J,1,A), Edges), member(edge(I,J,2,B), Edges), 
I1 #= I + 1, J1 #= J + 1, member(edge(I1,J1,3,C), Edges), member(edge(I1,J1,4,D), Edges), A + B + C + D #=< 3, constraintC(Cs,Edges). 

constraintC([clue(I,J,Clue)|Cs],Edges):- member(edge(I,J,1,A), Edges), member(edge(I,J,2,B), Edges), 
I1 #= I + 1, J1 #= J + 1, member(edge(I1,J1,3,C), Edges), member(edge(I1,J1,4,D), Edges), A + B + C + D #= Clue, constraintC(Cs,Edges).

constraintE([],_).
constraintE([dot(I,J)|Ds], Edges):- include(test(I,J),Edges,Dotedges), degreeTest(Dotedges), constraintE(Ds,Edges).

test(I,J,edge(K,L,_,_)):-I = K,J = L.

degreeTest([edge(_,_,_,A),edge(_,_,_,B),edge(_,_,_,C),edge(_,_,_,D)]):- ((A + B + C + D) #= 0) #\/ ((A + B + C + D) #= 2).
degreeTest([edge(_,_,_,A),edge(_,_,_,B),edge(_,_,_,C)]):- ((A + B + C) #= 0) #\/ ((A + B + C) #= 2).
degreeTest([edge(_,_,_,A),edge(_,_,_,B)]):- ((A + B) #= 0) #\/ ((A + B) #= 2).
loop :- solve(10,10,
[dot(1,1),
dot(1,2),
dot(1,3),
dot(1,4),
dot(1,5),
dot(1,6),
dot(1,7),
dot(1,8),
dot(1,9),
dot(1,10),
dot(1,11),
dot(2,1),
dot(2,2),
dot(2,3),
dot(2,4),
dot(2,5),
dot(2,6),
dot(2,7),
dot(2,8),
dot(2,9),
dot(2,10),
dot(2,11),
dot(3,1),
dot(3,2),
dot(3,3),
dot(3,4),
dot(3,5),
dot(3,6),
dot(3,7),
dot(3,8),
dot(3,9),
dot(3,10),
dot(3,11),
dot(4,1),
dot(4,2),
dot(4,3),
dot(4,4),
dot(4,5),
dot(4,6),
dot(4,7),
dot(4,8),
dot(4,9),
dot(4,10),
dot(4,11),
dot(5,1),
dot(5,2),
dot(5,3),
dot(5,4),
dot(5,5),
dot(5,6),
dot(5,7),
dot(5,8),
dot(5,9),
dot(5,10),
dot(5,11),
dot(6,1),
dot(6,2),
dot(6,3),
dot(6,4),
dot(6,5),
dot(6,6),
dot(6,7),
dot(6,8),
dot(6,9),
dot(6,10),
dot(6,11),
dot(7,1),
dot(7,2),
dot(7,3),
dot(7,4),
dot(7,5),
dot(7,6),
dot(7,7),
dot(7,8),
dot(7,9),
dot(7,10),
dot(7,11),
dot(8,1),
dot(8,2),
dot(8,3),
dot(8,4),
dot(8,5),
dot(8,6),
dot(8,7),
dot(8,8),
dot(8,9),
dot(8,10),
dot(8,11),
dot(9,1),
dot(9,2),
dot(9,3),
dot(9,4),
dot(9,5),
dot(9,6),
dot(9,7),
dot(9,8),
dot(9,9),
dot(9,10),
dot(9,11),
dot(10,1),
dot(10,2),
dot(10,3),
dot(10,4),
dot(10,5),
dot(10,6),
dot(10,7),
dot(10,8),
dot(10,9),
dot(10,10),
dot(10,11),
dot(11,1),
dot(11,2),
dot(11,3),
dot(11,4),
dot(11,5),
dot(11,6),
dot(11,7),
dot(11,8),
dot(11,9),
dot(11,10),
dot(11,11)],
[clue(1,1,-1),
clue(1,2,-1),
clue(1,3,-1),
clue(1,4,1),
clue(1,5,-1),
clue(1,6,-1),
clue(1,7,3),
clue(1,8,-1),
clue(1,9,-1),
clue(1,10,-1),
clue(2,1,-1),
clue(2,2,-1),
clue(2,3,-1),
clue(2,4,-1),
clue(2,5,-1),
clue(2,6,1),
clue(2,7,2),
clue(2,8,-1),
clue(2,9,3),
clue(2,10,3),
clue(3,1,2),
clue(3,2,1),
clue(3,3,1),
clue(3,4,-1),
clue(3,5,2),
clue(3,6,-1),
clue(3,7,-1),
clue(3,8,2),
clue(3,9,-1),
clue(3,10,-1),
clue(4,1,3),
clue(4,2,1),
clue(4,3,-1),
clue(4,4,-1),
clue(4,5,-1),
clue(4,6,0),
clue(4,7,2),
clue(4,8,-1),
clue(4,9,-1),
clue(4,10,-1),
clue(5,1,-1),
clue(5,2,-1),
clue(5,3,-1),
clue(5,4,-1),
clue(5,5,-1),
clue(5,6,2),
clue(5,7,-1),
clue(5,8,-1),
clue(5,9,-1),
clue(5,10,2),
clue(6,1,3),
clue(6,2,1),
clue(6,3,3),
clue(6,4,3),
clue(6,5,-1),
clue(6,6,1),
clue(6,7,2),
clue(6,8,2),
clue(6,9,-1),
clue(6,10,3),
clue(7,1,-1),
clue(7,2,-1),
clue(7,3,2),
clue(7,4,-1),
clue(7,5,3),
clue(7,6,2),
clue(7,7,-1),
clue(7,8,-1),
clue(7,9,-1),
clue(7,10,-1),
clue(8,1,1),
clue(8,2,1),
clue(8,3,-1),
clue(8,4,-1),
clue(8,5,-1),
clue(8,6,-1),
clue(8,7,1),
clue(8,8,2),
clue(8,9,-1),
clue(8,10,3),
clue(9,1,-1),
clue(9,2,-1),
clue(9,3,-1),
clue(9,4,-1),
clue(9,5,2),
clue(9,6,-1),
clue(9,7,2),
clue(9,8,-1),
clue(9,9,-1),
clue(9,10,-1),
clue(10,1,-1),
clue(10,2,-1),
clue(10,3,2),
clue(10,4,2),
clue(10,5,2),
clue(10,6,3),
clue(10,7,1),
clue(10,8,-1),
clue(10,9,2),
clue(10,10,-1)],
[edge(1,1,1,_),
edge(1,1,2,_),
edge(1,2,1,_),
edge(1,2,2,_),
edge(1,2,3,_),
edge(1,3,1,_),
edge(1,3,2,_),
edge(1,3,3,_),
edge(1,4,1,_),
edge(1,4,2,_),
edge(1,4,3,_),
edge(1,5,1,_),
edge(1,5,2,_),
edge(1,5,3,_),
edge(1,6,1,_),
edge(1,6,2,_),
edge(1,6,3,_),
edge(1,7,1,_),
edge(1,7,2,_),
edge(1,7,3,_),
edge(1,8,1,_),
edge(1,8,2,_),
edge(1,8,3,_),
edge(1,9,1,_),
edge(1,9,2,_),
edge(1,9,3,_),
edge(1,10,1,_),
edge(1,10,2,_),
edge(1,10,3,_),
edge(1,11,2,_),
edge(1,11,3,_),
edge(2,1,1,_),
edge(2,1,2,_),
edge(2,1,4,_),
edge(2,2,1,_),
edge(2,2,2,_),
edge(2,2,3,_),
edge(2,2,4,_),
edge(2,3,1,_),
edge(2,3,2,_),
edge(2,3,3,_),
edge(2,3,4,_),
edge(2,4,1,_),
edge(2,4,2,_),
edge(2,4,3,_),
edge(2,4,4,_),
edge(2,5,1,_),
edge(2,5,2,_),
edge(2,5,3,_),
edge(2,5,4,_),
edge(2,6,1,_),
edge(2,6,2,_),
edge(2,6,3,_),
edge(2,6,4,_),
edge(2,7,1,_),
edge(2,7,2,_),
edge(2,7,3,_),
edge(2,7,4,_),
edge(2,8,1,_),
edge(2,8,2,_),
edge(2,8,3,_),
edge(2,8,4,_),
edge(2,9,1,_),
edge(2,9,2,_),
edge(2,9,3,_),
edge(2,9,4,_),
edge(2,10,1,_),
edge(2,10,2,_),
edge(2,10,3,_),
edge(2,10,4,_),
edge(2,11,2,_),
edge(2,11,3,_),
edge(2,11,4,_),
edge(3,1,1,_),
edge(3,1,2,_),
edge(3,1,4,_),
edge(3,2,1,_),
edge(3,2,2,_),
edge(3,2,3,_),
edge(3,2,4,_),
edge(3,3,1,_),
edge(3,3,2,_),
edge(3,3,3,_),
edge(3,3,4,_),
edge(3,4,1,_),
edge(3,4,2,_),
edge(3,4,3,_),
edge(3,4,4,_),
edge(3,5,1,_),
edge(3,5,2,_),
edge(3,5,3,_),
edge(3,5,4,_),
edge(3,6,1,_),
edge(3,6,2,_),
edge(3,6,3,_),
edge(3,6,4,_),
edge(3,7,1,_),
edge(3,7,2,_),
edge(3,7,3,_),
edge(3,7,4,_),
edge(3,8,1,_),
edge(3,8,2,_),
edge(3,8,3,_),
edge(3,8,4,_),
edge(3,9,1,_),
edge(3,9,2,_),
edge(3,9,3,_),
edge(3,9,4,_),
edge(3,10,1,_),
edge(3,10,2,_),
edge(3,10,3,_),
edge(3,10,4,_),
edge(3,11,2,_),
edge(3,11,3,_),
edge(3,11,4,_),
edge(4,1,1,_),
edge(4,1,2,_),
edge(4,1,4,_),
edge(4,2,1,_),
edge(4,2,2,_),
edge(4,2,3,_),
edge(4,2,4,_),
edge(4,3,1,_),
edge(4,3,2,_),
edge(4,3,3,_),
edge(4,3,4,_),
edge(4,4,1,_),
edge(4,4,2,_),
edge(4,4,3,_),
edge(4,4,4,_),
edge(4,5,1,_),
edge(4,5,2,_),
edge(4,5,3,_),
edge(4,5,4,_),
edge(4,6,1,_),
edge(4,6,2,_),
edge(4,6,3,_),
edge(4,6,4,_),
edge(4,7,1,_),
edge(4,7,2,_),
edge(4,7,3,_),
edge(4,7,4,_),
edge(4,8,1,_),
edge(4,8,2,_),
edge(4,8,3,_),
edge(4,8,4,_),
edge(4,9,1,_),
edge(4,9,2,_),
edge(4,9,3,_),
edge(4,9,4,_),
edge(4,10,1,_),
edge(4,10,2,_),
edge(4,10,3,_),
edge(4,10,4,_),
edge(4,11,2,_),
edge(4,11,3,_),
edge(4,11,4,_),
edge(5,1,1,_),
edge(5,1,2,_),
edge(5,1,4,_),
edge(5,2,1,_),
edge(5,2,2,_),
edge(5,2,3,_),
edge(5,2,4,_),
edge(5,3,1,_),
edge(5,3,2,_),
edge(5,3,3,_),
edge(5,3,4,_),
edge(5,4,1,_),
edge(5,4,2,_),
edge(5,4,3,_),
edge(5,4,4,_),
edge(5,5,1,_),
edge(5,5,2,_),
edge(5,5,3,_),
edge(5,5,4,_),
edge(5,6,1,_),
edge(5,6,2,_),
edge(5,6,3,_),
edge(5,6,4,_),
edge(5,7,1,_),
edge(5,7,2,_),
edge(5,7,3,_),
edge(5,7,4,_),
edge(5,8,1,_),
edge(5,8,2,_),
edge(5,8,3,_),
edge(5,8,4,_),
edge(5,9,1,_),
edge(5,9,2,_),
edge(5,9,3,_),
edge(5,9,4,_),
edge(5,10,1,_),
edge(5,10,2,_),
edge(5,10,3,_),
edge(5,10,4,_),
edge(5,11,2,_),
edge(5,11,3,_),
edge(5,11,4,_),
edge(6,1,1,_),
edge(6,1,2,_),
edge(6,1,4,_),
edge(6,2,1,_),
edge(6,2,2,_),
edge(6,2,3,_),
edge(6,2,4,_),
edge(6,3,1,_),
edge(6,3,2,_),
edge(6,3,3,_),
edge(6,3,4,_),
edge(6,4,1,_),
edge(6,4,2,_),
edge(6,4,3,_),
edge(6,4,4,_),
edge(6,5,1,_),
edge(6,5,2,_),
edge(6,5,3,_),
edge(6,5,4,_),
edge(6,6,1,_),
edge(6,6,2,_),
edge(6,6,3,_),
edge(6,6,4,_),
edge(6,7,1,_),
edge(6,7,2,_),
edge(6,7,3,_),
edge(6,7,4,_),
edge(6,8,1,_),
edge(6,8,2,_),
edge(6,8,3,_),
edge(6,8,4,_),
edge(6,9,1,_),
edge(6,9,2,_),
edge(6,9,3,_),
edge(6,9,4,_),
edge(6,10,1,_),
edge(6,10,2,_),
edge(6,10,3,_),
edge(6,10,4,_),
edge(6,11,2,_),
edge(6,11,3,_),
edge(6,11,4,_),
edge(7,1,1,_),
edge(7,1,2,_),
edge(7,1,4,_),
edge(7,2,1,_),
edge(7,2,2,_),
edge(7,2,3,_),
edge(7,2,4,_),
edge(7,3,1,_),
edge(7,3,2,_),
edge(7,3,3,_),
edge(7,3,4,_),
edge(7,4,1,_),
edge(7,4,2,_),
edge(7,4,3,_),
edge(7,4,4,_),
edge(7,5,1,_),
edge(7,5,2,_),
edge(7,5,3,_),
edge(7,5,4,_),
edge(7,6,1,_),
edge(7,6,2,_),
edge(7,6,3,_),
edge(7,6,4,_),
edge(7,7,1,_),
edge(7,7,2,_),
edge(7,7,3,_),
edge(7,7,4,_),
edge(7,8,1,_),
edge(7,8,2,_),
edge(7,8,3,_),
edge(7,8,4,_),
edge(7,9,1,_),
edge(7,9,2,_),
edge(7,9,3,_),
edge(7,9,4,_),
edge(7,10,1,_),
edge(7,10,2,_),
edge(7,10,3,_),
edge(7,10,4,_),
edge(7,11,2,_),
edge(7,11,3,_),
edge(7,11,4,_),
edge(8,1,1,_),
edge(8,1,2,_),
edge(8,1,4,_),
edge(8,2,1,_),
edge(8,2,2,_),
edge(8,2,3,_),
edge(8,2,4,_),
edge(8,3,1,_),
edge(8,3,2,_),
edge(8,3,3,_),
edge(8,3,4,_),
edge(8,4,1,_),
edge(8,4,2,_),
edge(8,4,3,_),
edge(8,4,4,_),
edge(8,5,1,_),
edge(8,5,2,_),
edge(8,5,3,_),
edge(8,5,4,_),
edge(8,6,1,_),
edge(8,6,2,_),
edge(8,6,3,_),
edge(8,6,4,_),
edge(8,7,1,_),
edge(8,7,2,_),
edge(8,7,3,_),
edge(8,7,4,_),
edge(8,8,1,_),
edge(8,8,2,_),
edge(8,8,3,_),
edge(8,8,4,_),
edge(8,9,1,_),
edge(8,9,2,_),
edge(8,9,3,_),
edge(8,9,4,_),
edge(8,10,1,_),
edge(8,10,2,_),
edge(8,10,3,_),
edge(8,10,4,_),
edge(8,11,2,_),
edge(8,11,3,_),
edge(8,11,4,_),
edge(9,1,1,_),
edge(9,1,2,_),
edge(9,1,4,_),
edge(9,2,1,_),
edge(9,2,2,_),
edge(9,2,3,_),
edge(9,2,4,_),
edge(9,3,1,_),
edge(9,3,2,_),
edge(9,3,3,_),
edge(9,3,4,_),
edge(9,4,1,_),
edge(9,4,2,_),
edge(9,4,3,_),
edge(9,4,4,_),
edge(9,5,1,_),
edge(9,5,2,_),
edge(9,5,3,_),
edge(9,5,4,_),
edge(9,6,1,_),
edge(9,6,2,_),
edge(9,6,3,_),
edge(9,6,4,_),
edge(9,7,1,_),
edge(9,7,2,_),
edge(9,7,3,_),
edge(9,7,4,_),
edge(9,8,1,_),
edge(9,8,2,_),
edge(9,8,3,_),
edge(9,8,4,_),
edge(9,9,1,_),
edge(9,9,2,_),
edge(9,9,3,_),
edge(9,9,4,_),
edge(9,10,1,_),
edge(9,10,2,_),
edge(9,10,3,_),
edge(9,10,4,_),
edge(9,11,2,_),
edge(9,11,3,_),
edge(9,11,4,_),
edge(10,1,1,_),
edge(10,1,2,_),
edge(10,1,4,_),
edge(10,2,1,_),
edge(10,2,2,_),
edge(10,2,3,_),
edge(10,2,4,_),
edge(10,3,1,_),
edge(10,3,2,_),
edge(10,3,3,_),
edge(10,3,4,_),
edge(10,4,1,_),
edge(10,4,2,_),
edge(10,4,3,_),
edge(10,4,4,_),
edge(10,5,1,_),
edge(10,5,2,_),
edge(10,5,3,_),
edge(10,5,4,_),
edge(10,6,1,_),
edge(10,6,2,_),
edge(10,6,3,_),
edge(10,6,4,_),
edge(10,7,1,_),
edge(10,7,2,_),
edge(10,7,3,_),
edge(10,7,4,_),
edge(10,8,1,_),
edge(10,8,2,_),
edge(10,8,3,_),
edge(10,8,4,_),
edge(10,9,1,_),
edge(10,9,2,_),
edge(10,9,3,_),
edge(10,9,4,_),
edge(10,10,1,_),
edge(10,10,2,_),
edge(10,10,3,_),
edge(10,10,4,_),
edge(10,11,2,_),
edge(10,11,3,_),
edge(10,11,4,_),
edge(11,1,1,_),
edge(11,1,4,_),
edge(11,2,1,_),
edge(11,2,3,_),
edge(11,2,4,_),
edge(11,3,1,_),
edge(11,3,3,_),
edge(11,3,4,_),
edge(11,4,1,_),
edge(11,4,3,_),
edge(11,4,4,_),
edge(11,5,1,_),
edge(11,5,3,_),
edge(11,5,4,_),
edge(11,6,1,_),
edge(11,6,3,_),
edge(11,6,4,_),
edge(11,7,1,_),
edge(11,7,3,_),
edge(11,7,4,_),
edge(11,8,1,_),
edge(11,8,3,_),
edge(11,8,4,_),
edge(11,9,1,_),
edge(11,9,3,_),
edge(11,9,4,_),
edge(11,10,1,_),
edge(11,10,3,_),
edge(11,10,4,_),
edge(11,11,3,_),
edge(11,11,4,_)]), halt.