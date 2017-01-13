#ifndef MONOID_H
#define MONOID_H

#include <iostream>

typedef unsigned int ui;

class Monoid {
	
public:
	ui serial_number;
	const char input;
	const char* output;
	ui weight;
	Monoid(const char input, const char* output, ui weight):input(input), output(output), weight(weight){};
	
	friend std::ostream& operator<<(std::ostream& os, const Monoid& transducer);
};

#endif