#include <stdio.h>
#include "nfa.h"

int main(int argc, char **argv)
{
	NFA nfa;
	nfa.set_states_count(5);
	
	ui initial_states[3] = {1, 0, 2};
	nfa.set_initial_states(initial_states, 3);
	
	ui final_states[2] = {4, 3};
	nfa.set_final_states(final_states, 2);
	
	nfa.add_transition(0, 'a', 1);
	nfa.add_transition(0, 'b', 2);
	nfa.add_transition(0, 'a', 3);
	
	nfa.check_word("abcd");
	return 0;
}
