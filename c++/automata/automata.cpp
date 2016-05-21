#include "automata.h"
#include <string.h>
#include <algorithm>

Automata::Automata(): states_count(0), current_state(-1){}

const ui Automata::get_states_count() const {
	return states_count;
}

void Automata::set_states_count(const ui states_counst) {
	this->states_count = states_count;
}

const ui Automata::get_current_state() const {
	return current_state;
}

void Automata::set_current_state(const ui current_state) {
	this->current_state = current_state;
}

void Automata::reset() {
	current_state = -1;
}

const ui Automata::get_final_states_count() const {
	return final_states_count;
}

const ui* Automata::get_final_states() const {
	return final_states;
}

const ui Automata::symbol_to_index(const char symbol) const {
	return symbol - 'a';
}

const bool Automata::is_state_final(const ui state) const {
	ui first = 0, last = final_states_count - 1, index;
	if (final_states[0] > state || final_states[last] < state)
		return false;
	while(first <= last) {
		index = (first + last) / 2;
		if (final_states[index] < state)
			first = index + 1;
		else if (final_states[index] > state)
			last = index - 1;
		else
			return true;
	}
	return final_states[first] == state || final_states[last] == state;
}

void Automata::set_final_states(const ui* final_states, const ui final_states_count) {
	memcpy(this->final_states, final_states, sizeof(ui) * final_states_count);
	std::sort(this->final_states, this->final_states + final_states_count);
	this->final_states_count = final_states_count;
}