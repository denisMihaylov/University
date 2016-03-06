#include "automata.h"

//the type of the transition (ui) limits the states count to 4294967295
//because it is interpreted as -1

class NFA : public Automata {
	ui initial_states_count;
	ui initial_states[MAX_STATES_COUNT];

public:
	NFA();
	
	const ui get_initial_states_count() const;
	const ui* get_initial_states() const;
	void set_initial_states(const ui *initial_states, const ui initial_states_count);
	
	void add_transition(const ui start, const char letter, const ui end);
	const ui get_transition(const ui start, const char letter) const;
	
	bool check_word(const char* input);
};