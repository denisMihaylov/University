#include <bs_transducer.h>
#include <stdlib.h>

BerrySethiTransducer::BerrySethiTransducer(const char* alphabet, Monoid* monoid, ui monoids_count) {
	this->alphabet = alphabet;
	this->states_count = monoids_count;
	this->first_count = 1;
	this->last_count = 1;
	this->first = new ui[monoids_count];
	this->first[0] = 0;
	this->last = new ui[monoids_count];
	this->last[0] = 0;
	this->follow.reserve(monoids_count);
	this->q_map = new Monoid*[monoids_count];
	this->q_map[0] = monoid;
}

BerrySethiTransducer::BerrySethiTransducer(const char* alphabet, ui serial_number, Monoid* monoid) {
	this->alphabet = alphabet;
	this->states_count = 1;
	this->first_count = 1;
	this->last_count= 1;
	this->first = new ui[1];
	this->first[0] = 0;
	this->last = new ui[1];
	this->last[0] = 0;
	this->q_map = new Monoid*[1];
	this->q_map[0] = monoid;
}