#include "nfa.h"
#include <string.h>
#include <algorithm>

NFA::NFA(): Automata() {
	for (ui i = 0; i < MAX_ALPHABET_SIZE; i++) {
		memset(transition[i], -1, MAX_STATES_COUNT);
	}
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

void NFA::add_transition(const ui start, const char letter, const ui end) {
	transition[letter - 'a'][start] = end;
}

const ui NFA::get_transition(const ui start, const char letter) const {
	return transition[letter - 'a'][start];
}

bool NFA::check_word(const char* input) {
	reset();
	return true;
}