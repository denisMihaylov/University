#ifndef REG_EXP_H
#define REG_EXP_H

#include <stdio.h>
#include <string.h>

class RegExp {
	const char* expression;
public:
	RegExp(const char* expression):expression(expression){};
};

#endif