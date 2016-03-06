#include "automata.h"

class DFA : public Automata {
	ui initial_state;
	ui transition[MAX_ALPHABET_SIZE][MAX_STATES_COUNT];

public:
	DFA();

	const ui get_initial_state() const;
	void set_initial_state(const ui initial_state);

	void add_transition(const ui start, const char letter, const ui end);
	const ui get_transition(const ui start, const char letter) const;

	bool check_word(const char *input);
};