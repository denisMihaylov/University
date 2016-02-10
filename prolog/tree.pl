%binary tree
binary_tree([]).
%binary_tree([A, B]), binary_tree(A), binary_tree(B). Only binary_tree(B) gets calculated again

%make tree by vertex number.
binary_tree([], 0).
binary_tree([A, B], N):-N1 is N - 1, my_between(M, 0, N1), K is N1 - M, binary_tree(A, M), binary_tree(B, K).

%make tree by depth
