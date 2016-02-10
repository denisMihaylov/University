%checks if N can be presented as a multiplication of members of List
p(List, N):-divisors(N, Div), not((my_member(X, Div), not(my_member(X, List)))).