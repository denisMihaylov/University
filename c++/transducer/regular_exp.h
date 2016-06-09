#ifndef REG_EXP_H
#define REG_EXP_H

#include <stdio.h>
#include <string.h>
#include <transducer.h>
#include <bs_transducer.h>
#include <vector>

typedef unsigned int ui;

//In reverse polish notation
class RegExp {
	std::vector<BerrySethiTransducer*> transducers;
	const char* expression;
	const char* alphabet;
public:
	RegExp(const char* alphabet, const char* expression);
	BerrySethiTransducer* to_transducer();
private:
	const char* read_word(ui& i);
	ui read_number(ui& i);
};

#endif