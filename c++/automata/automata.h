#define MAX_ALPHABET_SIZE 27
#define MAX_STATES_COUNT 100
typedef unsigned int ui;

class DFA {
	int states_count;
	int current_state;
	int transision[MAX_STATES_COUNT][MAX_ALPHABET_SIZE];

public:
	DFA();
	
	ui get_states_count() const;
	void set_states_count(const ui states_count);
	
	ui get_current_state() const;
	void set_current_state(ui i);
	void reset();
};