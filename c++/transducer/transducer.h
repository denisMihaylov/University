#ifndef TRANSDUCER_H
#define TRANSDUCER_H

#include <monoid.h>
#include <pair.h>
#include <vector>

typedef unsigned int ui;
typedef std::vector<ui> states_vector;

class Transducer {
	const char* alphabet;
	ui states_count;
	ui starting_state;
	states_vector* receiving_states;
	std::vector<std::vector<pair<char*, ui> > > transitions;
	std::vector<char*> states_outputs;
public:
	Transducer(const char* alphabet);
	
	// setters
	void set_states_count(ui states_count);
	void set_receiving_states(states_vector* receiving_states, bool is_first_final);
	
	
private:
	void init_internal_members(const char* alphabet);
};

#endif