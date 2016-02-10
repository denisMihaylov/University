%Let [1,2,3] is the list representation of 123. Make a predicate for adding numbers using numbers less than 20
sum(A, B, Result):-my_reverse(A, RA), my_reverse(B, RB), sum_help(RA, RB, RReverse), my_reverse(RReverse, Result).
sum_help([], A, A).
sum_help(A, [], A).
sum_help([X], [Y], [H]):-H is X + Y, H < 10.
sum_help([X], [Y], [H, 1]):-Temp is X + Y, not(Temp < 10), H is Temp - 10.
sum_help([H1|T1], [H2|T2], [H|T]):-H is H1 + H2, H < 10, sum_help(T1, T2, T).
sum_help([H1|T1], [H2|T2], [H, HT|T]):-Temp is H1 + H2, not(Temp < 10), H is Temp - 10, sum_help(T1, T2, [H3|T]), HT is H3 + 1.

