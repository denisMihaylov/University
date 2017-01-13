#include <string.h>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

short next_char;
const int ALPHABET_SIZE = 26;
const int AUTOMATON_STATE_COUNT_LIMIT = (int)(1e8 * 2);
int MULTIPLE_TRANSITIONS_CAPACITY = (int)(3e7 * 2.7 * ALPHABET_SIZE);


short* single_label = (short*)calloc(AUTOMATON_STATE_COUNT_LIMIT, sizeof(short));
int* single_transition = (int*)calloc(AUTOMATON_STATE_COUNT_LIMIT, sizeof(int));
int* transition_index = (int*)calloc(AUTOMATON_STATE_COUNT_LIMIT, sizeof(int));
int* multiple_transitions = (int*)calloc(MULTIPLE_TRANSITIONS_CAPACITY, sizeof(int));
int last_transition_table_index = 0;
int qa;
int* suffix_link = (int*)calloc(AUTOMATON_STATE_COUNT_LIMIT, sizeof(int));
int* len = (int*)calloc(AUTOMATON_STATE_COUNT_LIMIT, sizeof(int));
int states_count = 1;
int transitions_count = 0;
int last = 0;
int n = 0;
int suffix_link_insert;

inline void insert_next_char();
inline void get_suffix_link();
inline void print_final_states_count();

int main(int argc, char* argv[]) {
	len[0] = 0;
	suffix_link[0] = -1;
	FILE *fp = fopen(argv[1], "r");
	while (true) {
		if ((next_char = (char)fgetc(fp)) == EOF) {
			break;
		}
		next_char -= 97;
		insert_next_char();
	}

	printf("%d\n", states_count);
	printf("%d\n", transitions_count);
	print_final_states_count();
	return 0;
}

inline int getTransition(int state, short character)
{
	if (transition_index[state] != 0) {
		return multiple_transitions[transition_index[state] + character];
	}
	if (single_label[state] == character) {
		return single_transition[state];
	}
	return 0;
}

inline int get_next_transition_index() {
	int result = ++last_transition_table_index * ALPHABET_SIZE;
	if (result >= MULTIPLE_TRANSITIONS_CAPACITY - ALPHABET_SIZE) {
		int* temp = multiple_transitions;
		MULTIPLE_TRANSITIONS_CAPACITY *= 2;
		multiple_transitions = (int*)calloc(MULTIPLE_TRANSITIONS_CAPACITY, sizeof(int));
		if (multiple_transitions == NULL) {
			printf("OUT OF MEMORY\n");
			exit(0);
		}
		memcpy(multiple_transitions, temp, MULTIPLE_TRANSITIONS_CAPACITY * sizeof(int) / 2);
		delete temp;
	}
	return result;
}

inline void addTransition(int state, int next_state, short character)
{
	if (transition_index[state] != 0) {
		if (multiple_transitions[transition_index[state] + character] == 0) {
			transitions_count++;
		}
		multiple_transitions[transition_index[state] + character] = next_state;
	} else if (single_transition[state] == 0 || character == single_label[state]) {
		if (!single_transition[state]) {
			transitions_count++;
		}
		single_transition[state] = next_state;
		single_label[state] = character;
	} else {
		transition_index[state] = get_next_transition_index();
		multiple_transitions[transition_index[state] + single_label[state]] = single_transition[state];
		multiple_transitions[transition_index[state] + character] = next_state;
		transitions_count++;
	}
}

inline void copy_transitions(int newState, int copiedState)
{
	if (transition_index[copiedState] != 0) {
		transition_index[newState] = get_next_transition_index();
		for (short i = 0; i < ALPHABET_SIZE; i++) {
			if ((multiple_transitions[transition_index[newState] + i] = multiple_transitions[transition_index[copiedState] + i])) {
				transitions_count++;
			}
		}
	} else {
		single_label[newState] = single_label[copiedState];
		single_transition[newState] = single_transition[copiedState];
		transitions_count++;
	}
	
}

inline void insert_next_char() {
	n++;
	len[states_count++] = n;
	get_suffix_link();
	if (suffix_link_insert < 0) {
		suffix_link[last] = 0;
	}
	else {
		if (len[qa] != len[suffix_link_insert] + 1) {
			len[states_count] = len[suffix_link_insert] + 1;
			copy_transitions(states_count, qa);
			suffix_link[states_count] = suffix_link[qa];
			suffix_link[last] = states_count;
			suffix_link[qa] = states_count;
			while (suffix_link_insert >= 0 && getTransition(suffix_link_insert, next_char) == qa) {
				addTransition(suffix_link_insert, states_count, next_char);
				suffix_link_insert = suffix_link[suffix_link_insert];
			}
			states_count++;
		}
		else {
			suffix_link[last] = qa;
		}
	}
}

inline void get_suffix_link() {
	suffix_link_insert = last;
	last = states_count - 1;
	while (suffix_link_insert >= 0 && (qa = getTransition(suffix_link_insert, next_char)) <= 0) {
		addTransition(suffix_link_insert, last, next_char);
		suffix_link_insert = suffix_link[suffix_link_insert];
	}
}

bool chech_word(char* s, int size) {
	int q = 0;
	for (int i = 0; i < size; i++) {
		q = getTransition(q, (short)(s[i] - 97));
		if (q == 0) {
			return false;
		}
	}
	int current = last;
	while (current >= 0) {
		if (current == q) {
			return true;
		}
	}
	return false;
}

inline void print_final_states_count() {
	int result = 0;
	int currentState = last;
	while (currentState >= 0) {
		result++;
		currentState = suffix_link[currentState];
	}
	printf("%d\n", result);
}