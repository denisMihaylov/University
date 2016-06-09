#include <regular_exp.h>
#include <string.h>
#include <stdlib.h>

RegExp::RegExp(const char* alphabet, const char* expression) {
	this->alphabet = alphabet;
	this->expression = expression;
	this->transducers.reserve(64);
}

BerrySethiTransducer* RegExp::to_transducer() {
	//This will be the numbers of the states in the final Berry-Sethi transducer
	ui monoids_count = 0;
	for (ui i = 0; i < strlen(expression); i++) {
		if (expression[i] == '<') {
			monoids_count++;
		}
	}
	
	bool is_first_monoid = true;
	ui serial_number = 0;
	for (ui i = 0; i < strlen(expression); i++) {
		switch(expression[i]) {
			case '<': {
					const char* input = read_word(i);
					const char* output = read_word(++i);
					i+=2;
					ui weight = read_number(i);
					serial_number++;
					Monoid monoid(input, output, weight);
					if (is_first_monoid) {
						BerrySethiTransducer* transducer = new BerrySethiTransducer(this->alphabet, &monoid, monoids_count);
						this->transducers.push_back(transducer);
					} else {
						this->transducers.push_back(new BerrySethiTransducer(this->alphabet, serial_number, &monoid));
					}
					is_first_monoid = false;
				}
				break;
			case '|':
				
				break;
			case '*':
				
				break;
			case '.':
				
				break;
		}
	}
	return this->transducers.at(0);
}

const char* RegExp::read_word(ui& i) {
	ui start = ++i;
	for(;expression[i] != ','; i++);
	char* word = (char*)malloc(sizeof (char) * 100);
	strncpy(word, expression + start, i - start);
	return word;
}

ui RegExp::read_number(ui& i) {
	ui result = 0;
	while(expression[i] != '>') {
		result = result * 10 + expression[i] - '0';
		i++;
	}
	return result;
}