#include "nfa.h"
#include <string.h>
#include <algorithm>

NFA::NFA(): Automata() {
	//do nothing for now
}

const ui NFA::get_initial_states_count() const {
	return initial_states_count;
}

const ui* NFA::get_initial_states() const {
	return initial_states;
}

void NFA::set_initial_states(const ui* initial_states, const ui initial_states_count) {
	memcpy(this->initial_states, initial_states, sizeof(ui) * initial_states_count);
	std::sort(this->initial_states, this->initial_states + initial_states_count);
	this->initial_states_count = initial_states_count;
}

void NFA::add_transition(const ui start, const char symbol, const ui end) {
	
}

const ui NFA::get_transition(const ui start, const char symbol) const {
	return 0;
}

bool NFA::check_word(const char* input) {
	reset();
	return true;
}