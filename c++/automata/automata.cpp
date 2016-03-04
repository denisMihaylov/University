#include "automata.h"
#include <string.h>

NDFA::NDFA() {
	states_count = 0;
	current_state = -1;
	for (ui i = 0; i < MAX_ALPHABET_SIZE; i++) {
		memset(transition[i], -1, MAX_STATES_COUNT);
	}
}

ui NDFA::get_states_count() const {
	return states_count;
}

void NDFA::set_states_count(const ui states_counst) {
	this->states_count = states_count;
}

ui NDFA::get_current_state() const {
	return current_state;
}

void NDFA::set_current_state(const ui current_state) {
	this->current_state = current_state;
}

void NDFA::reset() {
	current_state = -1;
}

void NDFA::add_transition(const ui start, const char letter, const ui end) {
	transition[letter - 'a'][start] = end;
}

ui NDFA::get_transition(const ui start, const char letter) const {
	return transition[letter - 'a'][start];
}