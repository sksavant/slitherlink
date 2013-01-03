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
