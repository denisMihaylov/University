%parent predicate
%parent(x, y). -> x is y's parent
parent(jack, jon).
parent(jack, jena).
parent(elena, jack).
parent(george, jack).
parent(elena, flin).
parent(flin, holan).

%grandparent predicate
%gp(x, y). -> x is y's grandparent
gp(X,Y):-parent(X, Z), parent(Z, Y).

%sibling predicate
%sibling(x, y). -> x and y are siblings
sibling(X, Y):-parent(Z, X), parent(Z, Y).

%cousin predicate
cousin(X, Y):-parent(X1, X), parent(Y1, Y), sibling(X1, Y1).