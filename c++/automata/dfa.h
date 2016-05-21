#ifndef DFA_H
#define DFA_H

#include "automata.h"

class DFA : public Automata {
	ui initial_state;
	ui transition[MAX_ALPHABET_SIZE][MAX_STATES_COUNT];

public:
	DFA();

	const ui get_initial_state() const;
	void set_initial_state(const ui initial_state);

	void add_transition(const ui start, const char symbol, const ui end);
	const ui get_transition(const ui start, const char symbol) const;

	bool check_word(const char *input);
};

#endif