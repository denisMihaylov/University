#include <regular_exp.h>
#include <string.h>
#include <stdlib.h>

RegExp::RegExp(char* expression) {
	this->operations.reserve(64);
	this->transducers.reserve(64);
	this->expression = expression;
	
	for (ui i = 0; i < strlen(expression); i++) {
		switch(expression[i]) {
			case '<': {
					char* input = read_word(i);
					char* output = read_word(++i);
					i+=2;
					ui weight = read_number(i);
					Monoid monoid(input, output, weight);
					this->transducers.push_back(new Transducer(monoid));
				}
				break;
			case '|':
				this->operations.push_back(UNION);
				break;
			case '*':
				this->operations.push_back(STAR);
				break;
			case '.':
				this->operations.push_back(CONCAT);
				break;
		}
	}
}

char* RegExp::read_word(ui& i) {
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