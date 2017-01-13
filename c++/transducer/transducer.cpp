#include <transducer.h>
#include <stdio.h>

Transducer::Transducer(const char* alphabet) {
	this->alphabet = alphabet;
	starting_state = 0;
}

void Transducer::set_states_count(ui states_count) {
	this->states_count = states_count;
}

void Transducer::set_receiving_states(states_vector* receiving_states, bool is_first_final) {
	this->receiving_states = receiving_states;
	if (is_first_final) {
		this->receiving_states->insert(this->receiving_states->begin(), 0);
	}
}