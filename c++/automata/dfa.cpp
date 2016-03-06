#include "dfa.h"
#include "string.h"
#include <algorithm>

DFA::DFA() : Automata() {
	for (ui i = 0; i < MAX_ALPHABET_SIZE; i++) {
		memset(transition[i], -1, MAX_STATES_COUNT);
	}
}

const ui DFA::get_initial_state() const {
	return initial_state;
}

void DFA::set_initial_state(const ui initial_state) {
	this->initial_state = initial_state;
}

void DFA::add_transition(const ui start, const char letter, const ui end) {
	transition[letter_to_index(letter)][start] = end;
}

const ui DFA::get_transition(const ui start, const char letter) const {
	return transition[letter_to_index(letter)][start];
}

bool DFA::check_word(const char* input) {
	ui state = initial_state;
	for (ui i = 0; i < strlen(input); i++) {
		state = get_transition(state, input[i]);
		if (state == -1) {
			return false;
		}
	}
	return is_state_final(state);
}