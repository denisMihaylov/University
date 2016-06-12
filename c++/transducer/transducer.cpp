#include <transducer.h>
#include <stdio.h>



void Transducer::init_internal_members(const char* alphabet) {
	this->alphabet = alphabet;
	this->states_count = 0;
	this->final_states.reserve(16);
}

Transducer::Transducer() {
	this->init_internal_members(alphabet);
}