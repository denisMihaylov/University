#include <transducer.h>
#include <stdio.h>



void Transducer::init_internal_members(const char* alphabet) {
	this->alphabet = alphabet;
	this->states_count = 0;
	this->starting_state = -1;
	this->final_states.reserve(16);
}

Transducer::Transducer(const char* alphabet) {
	this->init_internal_members(alphabet);
}

Transducer::Transducer(const char* alphabet, Monoid& monoid) {
	this->init_internal_members(alphabet);
	
	
}