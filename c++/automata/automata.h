#define MAX_ALPHABET_SIZE 27
#define MAX_STATES_COUNT 100
typedef unsigned int ui;

class Automata {

protected:
	ui states_count;
	ui current_state;
	ui final_states_count;
	ui final_states[MAX_STATES_COUNT];
	
public:
	Automata();

	const ui get_states_count() const;
	void set_states_count(const ui states_count);
	
	const ui get_current_state() const;
	void set_current_state(const ui current_state);
	void reset();
	
	const ui get_final_states_count() const;
	const ui* get_final_states() const;
	void set_final_states(const ui* final_states, const ui final_states_count);

	virtual void add_transition(const ui start, const char letter, const ui end) = 0;
	
	virtual bool check_word(const char* word) = 0;
};