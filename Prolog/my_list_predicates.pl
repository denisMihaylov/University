%first item in the list
%first(list, first_member).
first([X|_], X).

%last item in the list
%last(list, last_item)
last([X], X).
last([_|T], X):-last(T, X).

%member predicate
%my_member(number, list).
my_member(X, [X|_]).
my_member(X, [_|T]):-my_member(X, T).

%append predicate
%my_append(list1, list2, result_list).
my_append([], List, List).
my_append([H|T], List, [H|List1]):-my_append(T, List, List1).

%prefix predicate
%prefix(Prefix, List).
prefix(Prefix, List):-my_append(Prefix, _, List).

%suffix predicate
%suffix(Suffix, List).
suffix(Suffix, List):-my_append(_, Suffix, List).

%sublist predicate
%my_sublist(Sublist, List).
my_sublist(Sublist, List):-suffix(Suffix, List), prefix(Sublist, Suffix).
my_sublist2(Sublist, List):-my_append(B, _, List), my_append(_, Sublist, B).

last2(List, Last):-suffix([Last], List).
last3(List, Last):-my_append(_, [Last], List).

%subset predicate
%subset(subset, list).
subset_wrong([H|T], L):-member(H, L), subset(T, L). %endless cycle -> not a single result
subset([], _).
subset([H|S], [H|T]):-subset(S, T).
subset(S, [_|T]):-subset(S, T).

subset2([], _).
subset2([H|S], List):-my_append(_, [H|B], List), subset(S, B).

%remove predicate
%remove(X, List, Result)
remove_bad(X, List, Result):-my_append(A, [X| B], List), my_append(A, B, Result). %remove(3, X, [1,2,4]) cycles!
remove(X, [X|T], T).
remove(X, [H|T], [H|L]):-remove(X, T, L).

%add predicate
%add(X, List, Result)
add(X, List, Result):-remove(X, Result, List).

%permutation predicate
%perm(Perm, List).
perm([], []).
perm([H|T], List):-remove(H, List, List1), perm(T, List1).

perm2([], []).
perm2(Perm, [H|T]):-perm2(AB, T), my_append(A, B, AB), my_append(A, [H|B], Perm).

%any-p -> is there any member X of the List that p(X)
any-p(List):-member(X, List), even(X).

%all-p -> for every member X of the List => p(X)
all-p(List):-not(( member(X, List), not(even(X)) )).

%min(Min, List) -> finds the minimal element of a List. Pretty slow.
min_bad(Min, [Min]).
min_bad(Min, [H|T]):-min_bad(Min, T), less(Min, H).
min_bad(Min, [Min|T]):-min_bad(H, T), not(less(H, Min)).

min(Min, [Min]).
min(Min, [H|T]):-min(Min1, T), min_help(Min1, H, Min).
min_help(A, B, A):-less(A, B).
min_help(A, B, B):-not(less(A, B)).

min2(Min, [Min]).
min2(Min, List):-member(Min, List), not(( member(X, List), less(X, Min) )).

%length predicate
my_length([], 0).
my_length([_|T], Length):-my_length(T, Length1), Length is Length1 + 1.

%sum predicate
sum([], 0).
sum([H|T], Sum):- sum(T, Sum1), Sum is Sum1 + H.

%nmember predicate -> the nth member of the list. Indexing starts from 0.
%this works only when trying to find the nth member. ?- nmember([1,2,3], X, N) will fail
nmember_bad([H|_], 0, H).
nmember_bad([_|T], N, H):-N1 is N - 1, nmember_bad(T, N1, H).

nmember([H|_], 0, H).
nmember([_|T], N, H):-nmember(T, N1, H), N is N1 + 1.

%reverse predicate
%reverse(List, Reversed).
my_reverse([], []).
my_reverse([H|T], Reversed):-my_reverse(T, Reversed1), my_append(Reversed1, [H], Reversed).

%split predicate -> splits a list into a list of lists.
split([], []).
split(List, [Pref|T]):-my_append(Pref, Suff, List), Pref \= [], split(Suff, T).












