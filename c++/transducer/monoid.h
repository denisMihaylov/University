#ifndef MONOID_H
#define MONOID_H

typedef unsigned int ui;

struct Monoid {
	char* input;
	char* output;
	ui weight;
	Monoid(){};
	Monoid(char* input, char* output, int weight):input(input), output(output), weight(weight){};
};

#endif