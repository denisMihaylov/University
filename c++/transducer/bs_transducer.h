#ifndef BS_TRANSDUCER
#define BS_TRANSDUCER

#include <monoid.h>
#include <vector>
#include <pair.h>

typedef unsigned int ui;

class BerrySethiTransducer {
	const char* alphabet;
	ui states_count;
	ui* first;
	ui first_count;
	ui* last;
	ui last_count;
	std::vector<pair<ui, ui> > follow;
	bool is_first_final;
	Monoid** q_map;
	
public:
	BerrySethiTransducer(const char* alphabet, Monoid* monoid, ui monoids_count);
	BerrySethiTransducer(const char* alphabet, ui serial_number, Monoid* monoid);
};

#endif