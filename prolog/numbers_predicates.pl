even(X):-0 is X mod 2.
odd(X):-not(even(X)).
less(X, Y):-X < Y.
less_equal(X, Y):-X =< Y.

%all natural numbers
n(0).
n(N):-n(N1), N is N1 + 1.

%between predicate
my_between(A, A, B):-A =< B.
my_between(X, A, B):-A < B, A1 is A + 1, my_between(X, A1, B).

%all couples of natural numbers
nat2(A, B):-n(N), my_between(A, 0, N), B is N - A.

%fibonacci numbers
fib(X):-fib(X, _).
fib(0, 1).
fib(B, C):-fib(A, B), C is A + B.

%whole numbers predicate
sign(1).
sign(-1).
z(0).
z(N):-n(N1), N2 is N1 + 1, sign(S), N is N2*S.

%d(X, Y) -> X devides Y with remainder 0
d(X, Y):-0 is Y mod X.

%prime -> checks if X is prime
prime(X):-X > 1, X1 is X - 1, not(( my_between(X2, 2, X1), d(X2, X))).

%prime devisors of X
prime_devisor(X, D):-my_between(D, 2, X), prime(D), d(D, X).

divisors(1, []).
divisors(N, [X|Divisors]):-my_between(X, 2, N), d(X, N), N1 is N/X, divisors(N1, Divisors).









