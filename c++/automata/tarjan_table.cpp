#include "tarjan_table.h"
#include <string.h>

TarjanTable::TarjanTable() {
	transitions_capacity = INITIAL_TRANSITIONS_CAPACITY;
	transitions = new Pair<char, ui>[transitions_capacity];
	transitions_count = 0;
	
	state_starts_capacity = INITIAL_TRANSITIONS_CAPACITY;
	state_starts = new ui[state_starts_capacity];
	state_starts_count = 0;
	first_possible_index = 0;
}

void TarjanTable::add_transitions(const Pair<char, ui>* transitions, const ui transitions_count, const ui start_state) {
	ui index = first_possible_index - OFFSET;
	if (index < 0)
		index = 0;
	for (bool found = false; !found; index++) {
		found = true;
		for (ui j = 0; j < transitions_count; j++) {
			if (this->transitions[index + transitions[j].first - 'a'].first != -1) {
				found = false;
				break;
			}
		}
		for (int symbol_index = 0; symbol_index <= 'a' - 'z' && found; symbol_index++)
			if (this->transitions[index + symbol_index].first == 'a' + symbol_index)
				found = false;
	}
	//update the first possible index
	if (index + transitions[transitions_count - 1].first >= first_possible_index)
		first_possible_index = index + transitions[transitions_count - 1].first + 1;

	if (this->state_starts_capacity <= start_state) {
		ui* temp = this->state_starts;
		ui next_capacity = this->state_starts_capacity * 2;
		if (next_capacity <= start_state)
			next_capacity = start_state + 1;
		this->state_starts = new ui[next_capacity];
		memcpy(this->state_starts, temp, sizeof(ui) * this->state_starts_capacity);
		this->state_starts_capacity = next_capacity;
	}
	this->state_starts[start_state] = index;
	for (ui j = 0; j < transitions_count; j++) {
		this->transitions[index + transitions[j].first - 'a'] = transitions[j];
	}
}

const ui TarjanTable::get_transition(const ui state, const char symbol) const {
	
}