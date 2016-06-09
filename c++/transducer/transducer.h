#ifndef TRANSDUCER_H
#define TRANSDUCER_H

#include <monoid.h>
#include <pair.h>
#include <vector>

typedef unsigned int ui;

class Transducer {
	const char* alphabet;
	ui states_count;
	ui starting_state;
	std::vector<ui> final_states;
	std::vector<std::vector<pair<char*, ui> > > transitions;
	std::vector<char*> states_outputs;
public:
	Transducer(const char* alphabet);
	Transducer(const char* alphabet, Monoid& monoid);
	
private:
	void init_internal_members(const char* alphabet);
};

#endif