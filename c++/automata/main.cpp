#include <stdio.h>
#include "dfa.h"

void dfa_test();

int main(int argc, char **argv)
{
	//dfa_test();
	return 0;
}

void dfa_test() {
	DFA dfa;
	dfa.set_states_count(5);

	//ui initial_states[3] = {1, 0, 2};
	dfa.set_initial_state(0);

	ui final_states[2] = {4, 3};
	dfa.set_final_states(final_states, 2);

	dfa.add_transition(0, 'a', 1);
	dfa.add_transition(0, 'b', 2);
	dfa.add_transition(1, 'b', 2);
	dfa.add_transition(1, 'c', 3);
	dfa.add_transition(2, 'c', 3);
	dfa.add_transition(3, 'd', 4);
	dfa.add_transition(4, 'd', 4);

	printf("%s\n", dfa.check_word("bcddd") ? "true" : "false");
}
