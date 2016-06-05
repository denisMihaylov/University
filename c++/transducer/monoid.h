#ifndef MONOID_H
#define MONOID_H

struct Monoid {
	char* first;
	char* second;
	int third;
	Monoid(char* first, char* second, int third):first(first), second(second), third(third){};
};

#endif