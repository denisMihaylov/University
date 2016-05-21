#ifndef TARJAN_TABLE_H
#define TARJAN_TABLE_H

#include "pair.h"

#define INITIAL_TRANSITIONS_CAPACITY 64
#define OFFSET 5 * 27
typedef unsigned int ui;

class TarjanTable {
	ui transitions_capacity;
	ui transitions_count;
	Pair<char, ui>* transitions;
	ui state_starts_capacity;
	ui state_starts_count;
	ui* state_starts;
	ui first_possible_index;

public:

	TarjanTable();
	void add_transitions(const Pair<char, ui>* transitions, const ui transitions_count, const ui start_state);
	const ui get_transition(const ui state, const char symbol) const;
};

#endif