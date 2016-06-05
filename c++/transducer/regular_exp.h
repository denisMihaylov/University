#ifndef REG_EXP_H
#define REG_EXP_H

#include <stdio.h>
#include <string.h>
#include <transducer.h>
#include <vector>

typedef unsigned int ui;

enum RegExpOperation {
	STAR,
	UNION,
	CONCAT
};

//In reverse polish notation
class RegExp {
	std::vector<RegExpOperation> operations;
	std::vector<Transducer*> transducers;
	char* expression;
public:
	RegExp(char* expression);
private:
	char* read_word(ui& i);
	ui read_number(ui& i);
};

#endif