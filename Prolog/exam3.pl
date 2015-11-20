%Let [1,2,3] is the list representation of 123.
%Make a predicate for multiplying by 7 without arithmetics with numbers larger than 100
p(List, Result):-my_reverse(List, Reversed), p_help(Reversed, RResult), my_reverse(RResult, Result).
p_help([1], [7]).
p_help([H], [A, B]):- H1 is H * 7, A is H1 mod 10, HH is H1 - A, B is HH / 10.
p_help([1|T1], [7|T]):-p_help(T1, T).
p_help([H1|T1], [H|TT]):-p_help(T1, [H2|T]), p_help([H1], [H, HTT]), split1(H2, HTT, HT), my_append(HT, T, TT).
split1(A, B, [Res]):-Res is A + B, Res < 10.
split1(A, B, [Res, 1]):-Temp is A + B, not(Temp < 10), Res is Temp - 10.


