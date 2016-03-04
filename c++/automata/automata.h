#define MAX_ALPHABET_SIZE 27
#define MAX_STATES_COUNT 100
typedef unsigned int ui;

//the type of the transition (ui) limits the states count to 4294967295
//because it is interpreted as -1

class NDFA {
	ui states_count;
	ui current_state;
	ui final_states_count;
	ui initial_states_count;
	ui final_state[MAX_STATES_COUNT];
	ui initial_state[MAX_STATES_COUNT];
	ui transition[MAX_ALPHABET_SIZE][MAX_STATES_COUNT];

public:
	NDFA();
	
	ui get_states_count() const;
	void set_states_count(const ui states_count);
	
	ui get_current_state() const;
	void set_current_state(const ui current_state);
	void reset();
	
	void add_transition(const ui start, const char letter, const ui end);
	ui get_transition(const ui start, const char letter) const;
};