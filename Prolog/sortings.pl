%sorted(List) -> checks if List is sorted
sorted([]).
sorted([_]).
sorted([X, Y|T]):-less(X, Y), sorted([Y|T]).

sorted2([]).
sorted2([_]).
sorted2(List):-not(( my_sublist([X, Y], List), not(less(X, Y)) )).

%permutation sort -> checks all permutations to find the sorted one. Pretty slow.
psort(List, Sorted):-perm(Sorted, List), sorted(Sorted).

%selection sort predicate
%selection_sort(List, Sorted).
selection_sort([], []).
selection_sort(List, [Min|T1]):-min(Min, List), remove(Min, List, List1), selection_sort(List1, T1).

%my_partition predicate
%my_partition(X, List, Lows, Highs). -> devides the List into 2 lists A and B respectively containing
%the elements lower and bigger than X
my_partition(_, [], [], []).
my_partition(X, [H|T], [H|T1], Highs):-less(H, X), my_partition(X, T, T1, Highs).
my_partition(X, [H|T], Lows, [H|T1]):-not(less(H, X)), my_partition(X, T, Lows, T1).

%quick sort predicate
%quick_sort(List, Sorted).
quick_sort([], []).
quick_sort([H|T], Sorted):-my_partition(H, T, Lows, Highs), quick_sort(Lows, SortedLows), 
		quick_sort(Highs, SortedHighs), my_append(SortedLows, [H|SortedHighs], Sorted).
		
%tree sort -> [Root, Left, Right], [] or t(Root, Left, Right), t
%tsort(List, Sorted).
%make_tree(List, Tree).
%add(X, Tree, New_tree).
%walk(Tree, Sorted).
make_tree([], []).
make_tree([H|T], Tree):-make_tree(T, Tree1), add_to_tree(H, Tree1, Tree).
make_tree1([], t). % t is the empty tree. The base of all trees
make_tree1([H|T], Tree):-make_Tree(T, Tree1), add_to_tree(H, Tree1, Tree).

add_to_tree(X, [], [X, [], []]).
add_to_tree(X, [Root, Left, Right], [Root, New_left, Right]):-less(X, Root), add_to_tree(X, Left, New_left).
add_to_tree(X, [Root, Left, Right], [Root, Left, New_right]):-not(less(X, Root)), add_to_tree(X, Right, New_right).

add_to_tree1(X, t, t(X, t, t)).
add_to_tree1(X, t(Root, Left, Right), t(Root, New_left, Right)):-less(X, Root), add_to_tree1(X, Left, New_left).
add_to_tree1(X, t(Root, Left, Right), t(Root, Left, New_right)):-not(less(X, Root)), add_to_tree1(X, Right, New_right).

walk([], []).
walk([Root, Left, Right], List):-walk(Left, Left_list), walk(Right, Right_list), my_append(Left_list, [Root|Right_list], List).

walk1(t, []).
walk1(t(Root, Left, Right), List):-walk(Left, Left_list), walk(Right, Right_list), my_append(Left_list, [Root|Right_list], List).

tree_sort(List, Sorted):-make_tree(List, Tree), walk(Tree, Sorted).
tree_sort1(List, Sorted):-make_tree1(List, Tree), walk(Tree, Sorted).








