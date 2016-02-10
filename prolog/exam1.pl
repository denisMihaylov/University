%X is List of numbers, Y is List of Lists of numbers
%p1(X, Y) -> there is A from X such that A is member B from Y
p1(X, Y):-my_member(A, X), my_member(B, Y), my_member(A, B).

%p2(X, Y) -> there is A from X such that A is member of every B from Y
p2(X, Y):-my_member(A, X), not((my_member(B, Y), not(my_member(A, B)))).

%p3(X, Y) -> every A of X is member of some B that is member of Y
p3(X, Y):-not(( my_member(A, X), not(( my_member(B, Y), my_member(A, B) )) )).

%p4(X, Y) -> every A of X is member of every B of Y
p4(X, Y):-not(( my_member(A, X), my_member(B, Y), not(my_member(A, B)) )).