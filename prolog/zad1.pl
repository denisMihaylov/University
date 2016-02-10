%предикат p(N, K), който по дадено число N намира в К
%най-малкия прост делител на N

d(Y, X):-0 is X mod Y.

my_between(A, A, B):-A =< B.
my_between(X, A, B):-A =< B, A1 is A + 1, my_between(X, A1, B).

prime(X):-X > 1, X1 is X - 1, not((my_between(Y, 2, X1), d(Y, X))).

remove(_, [], []).
remove(X, [X|T], Result):-remove(X, T, Result).
remove(X, [H|T], [H|Result]):-not(X is H), remove(X, T, Result).

my_partition(_, [], [], []).
my_partition(X, [H|T], [H|Lows], Highs):-H =< X, my_partition(X, T, Lows, Highs).
my_partition(X, [H|T], Lows, [H|Highs]):-not(H =< X), my_partition(X, T, Lows, Highs).

my_append([], B, B).
my_append([H|A], B, [H|T]):-my_append(A, B, T).

qsort([], []).
qsort([H|T], Result):-my_partition(H, T, Lows, Highs), qsort(Lows, SortedL), qsort(Highs, SortedH), my_append(SortedL, [H|SortedH], Result).

member(X, [X|_]).
member(X, [_|T]):-member(X, T).

pd(X, N):- prime(X), d(X, N).

p(N, K):-my_between(K, 2, N), pd(K, N), not((K > 2, X1 is K - 1, my_between(X2, 2, X1), pd(X2, N))).

div(N, H, N):-not(d(N, H)).
div(N, H, M):-d(N, H), N1 is N / H, div(M1, H, M).

q(N, K, []):-not(p(N, K, _)).
q(N, K, [A|T]):-p(N, K, A), remove(A, K, Res), q(N, Res, T).
