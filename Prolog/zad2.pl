%Да се дефинират предикати p(X), q(X), r(X), такива че
%ако X е списък от списъци то:
%	1) p(X) <-> два от елементите на някой елемент на X са 5
%	2) q(X) <-> всеки два елемента на X имат поне три различни общи елемента
%	3) r(X) <-> съществува такива ненулево естествено число N, че X съдържа N различни помежду си елемента, 
%	   всеки от които има не повече от 2*N елемента

my_count(_, [], 0).
my_count(X, [X|T], C):-my_count(X, T, C1), C is C1 + 1.
my_count(X, [H|T], C):-not(X is H), my_count(X, T, C).

my_length([], 0).
my_length([_|T], C):-my_length(T, C1), C is C1 + 1.

my_member(X, [X|_]).
my_member(X, [_|T]):-my_member(X, T).

p(X):-my_member(A, X), my_count(5, A, C), C is 2.

inter(A, B, L):-inter1(A, B, L, []).
inter1([], _, [], _).
inter1([H|T], A, L, Res):-my_member(H, Res), inter1(T, A, L, Res).
inter1([H|T], A, L, Res):-not(my_member(H, A)), inter1(T, A, L, Res).
inter1([H|T], A, [H|L], Res):-not(my_member(H, Res)), my_member(H, A), inter1(T, A, L, [H|Res]).

q(X):-not((my_member(A, X), my_member(B, X), inter(A, B, I), my_length(I, C), C < 3)).

maxN([], 0).
maxN([H|T], Res):-my_length(H, C), maxN1(T, C, Res).
maxN1([], Res, Res).
maxN1([H|T], A, Res):-my_length(H, C), A < C, maxN1(T, C, Res).
maxN1([H|T], A, Res):-my_length(H, C), not(A < C), maxN1(T, A, Res).

my_between(A, A, B):- A =< B.
my_between(X, A, B):-A1 is A + 1, my_between(X, A1, B).

r(X):-maxN(X, MaxN2), N is MaxN2 / 2, my_between(C, 1, N), 





