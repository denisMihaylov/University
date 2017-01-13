#include <regular_exp.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>

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
	std::cout<<"MONOIDS COUNT: "<<monoids_count<<std::endl;
	bool is_first_monoid = true;
	ui first_state = 1;
	for (ui i = 0; i < strlen(expression); i++) {
		switch(expression[i]) {
			case '<': {
					const char* input = read_word(i);
					const char* output = read_word(++i);
					i+=2;
					ui weight = read_number(i);
					Monoid* monoid = new Monoid(input[0], output, weight);
					BerrySethiTransducer* transducer = NULL;
					if (is_first_monoid) {
						transducer = new BerrySethiTransducer(this->alphabet, monoid, monoids_count);
						this->transducers.push_back(transducer);
						is_first_monoid = false;
					} else {
						transducer = new BerrySethiTransducer(this->alphabet, first_state, monoid);
						this->transducers.push_back(transducer);
					}
					for (ui i = 1; i < strlen(input); i++) {
						first_state++;
						Monoid* monoid1 = new Monoid(input[i], "", 0);
						BerrySethiTransducer transducer1(this->alphabet, first_state, monoid1);
						transducer->concat(&transducer1);
					}
					std::cout<<"TRANSDUCER #"<< first_state << ": "<< (*transducer)<<std::endl<<std::endl;
					first_state++;
				}
				break;
			case '|': {
					BerrySethiTransducer* second = this->transducers.back();
					this->transducers.pop_back();
					BerrySethiTransducer* first = this->transducers.back();
					std::cout<<"UNION"<<std::endl;
					std::cout<<"1."<< (*first)<<std::endl;
					std::cout<<"2."<< (*second)<<std::endl;
					first->bs_union(second);
					std::cout<<"AFTER UNION"<<std::endl;
					std::cout<<(*first)<<std::endl;
					delete second;
				}
				break;
			case '*': {
					BerrySethiTransducer* transducer = this->transducers.back();
					std::cout<<"STAR"<<std::endl;
					std::cout<<(*transducer)<<std::endl;
					transducer->star();
					std::cout<<"AFTER STAR"<<std::endl;
					std::cout<<(*transducer)<<std::endl;
				}
				break;
			case '.': {
					BerrySethiTransducer* second = this->transducers.back();
					this->transducers.pop_back();
					BerrySethiTransducer* first = this->transducers.back();
					std::cout<<"CONCAT"<<std::endl;
					std::cout<<"1."<< (*first)<<std::endl;
					std::cout<<"2."<< (*second)<<std::endl;
					first->concat(second);
					std::cout<<"AFTER CONCAT"<<std::endl;
					std::cout<<(*first)<<std::endl;
					delete second;
				}
				break;
		}
	}
	return this->transducers.back();
}

const char* RegExp::read_word(ui& i) {
	ui start = ++i;
	for(;expression[i] != ','; i++);
	char* word = (char*)malloc(sizeof (char) * (i - start + 1));
	strncpy(word, expression + start, i - start);
	word[i - start] = '\0';
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