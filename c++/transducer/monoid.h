#ifndef MONOID_H
#define MONOID_H

typedef unsigned int ui;

class Monoid {
	
public:
	ui serial_number;
	const char* input;
	const char* output;
	ui weight;
	Monoid(){};
	Monoid(const char* input, const char* output, ui weight):input(input), output(output), weight(weight){};
};

#endif